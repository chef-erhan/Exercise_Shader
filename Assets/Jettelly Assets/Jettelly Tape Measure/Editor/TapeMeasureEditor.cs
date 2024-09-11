using UnityEngine;
using UnityEditor;

[InitializeOnLoadAttribute]
[CustomEditor(typeof(TapeMeasureController))]
public class TapeMeasureEditor : Editor
{
    TapeMeasureController _rulerVR;

    SerializedProperty _propToolHidden;
    SerializedProperty _propTapeWidth;
    SerializedProperty _propPoints;
    SerializedProperty _propUnit;

    private void OnEnable()
    {
        _rulerVR = (TapeMeasureController)target;

        _propToolHidden = serializedObject.FindProperty("IsToolHidden");
        _propTapeWidth = serializedObject.FindProperty("SetTapeWidth");
        _propPoints = serializedObject.FindProperty("Points");
        _propUnit = serializedObject.FindProperty("Unit");

        SetToolsState();

        _rulerVR.InitMesh();
        _rulerVR.SetMesh();
    }

    private void OnDisable()
    {
        SetToolsState();
    }

    public override void OnInspectorGUI()
    {
        serializedObject.Update();

        EditorGUILayout.PropertyField(_propUnit);
        EditorGUILayout.LabelField("Unit Value: " + _rulerVR.UnitValue);

        EditorGUILayout.Space(10);
        EditorGUILayout.PropertyField(_propPoints);
        EditorGUILayout.PropertyField(_propToolHidden, new GUIContent("Is Transform Hidden?"));
        EditorGUILayout.PropertyField(_propTapeWidth, new GUIContent("Set Tape Width"));
        

        if (serializedObject.ApplyModifiedProperties() || UndoChanges())
        {
            Tools.hidden = _rulerVR.IsToolHidden;
            float scale = _rulerVR.SetTapeWidth;
            
            _rulerVR.Vertices[0].y = -scale;
            _rulerVR.Vertices[1].y = scale;
            _rulerVR.Vertices[2].y = -scale;
            _rulerVR.Vertices[3].y = scale;

            _rulerVR.SetMesh();
            SceneView.RepaintAll();
        }
    }

    private void SetToolsState()
    {
        _rulerVR.IsToolHidden = false;
        Tools.hidden = _rulerVR.IsToolHidden;
    }

    // If you press Undo (Ctrl + Z).
    private bool UndoChanges()
    {
        return Event.current.type == EventType.ValidateCommand && Event.current.commandName == "UndoRedoPerformed";
    }

    private void OnSceneGUI()
    {
        for (int i = 0; i < _rulerVR.Points.Length; i++)
        {
            Vector3 localPoints = _rulerVR.transform.TransformPoint(_rulerVR.Points[i]);
            Vector3 p = Handles.PositionHandle(localPoints, Quaternion.identity);

            if (p != localPoints)
            {
                Undo.RecordObject(_rulerVR, "Move");
                _rulerVR.Points[i] = _rulerVR.transform.InverseTransformPoint(p);
                _rulerVR.SetMesh();
            }
        }

        // Draw the mesh if you press Undo.
        if (UndoChanges())
        {
            _rulerVR.SetMesh();
        }

        // Enable tool (transform, rotation and scale) after unselect the ruler.
        if (Selection.activeGameObject == null || Selection.activeGameObject.name != _rulerVR.name && _rulerVR.IsToolHidden)
        {
            SetToolsState();
        }

        DrawHandles();
    }

    // Draw some gizmos on the scene view.
    private void DrawHandles()
    {
        Vector3 p0 = _rulerVR.Points[0];
        Vector3 p1 = _rulerVR.Points[1];

        Vector3 v0 = _rulerVR.LocalPosition(p0, _rulerVR.Vertices[0]);
        Vector3 v1 = _rulerVR.LocalPosition(p0, _rulerVR.Vertices[1]);
        Vector3 v2 = _rulerVR.LocalPosition(p1, _rulerVR.Vertices[2]);
        Vector3 v3 = _rulerVR.LocalPosition(p1, _rulerVR.Vertices[3]);        

        Handles.color = Color.black;
        Handles.DrawAAPolyLine(3f, v0, v1);
        Handles.DrawAAPolyLine(3f, v2, v3);
        Handles.DrawAAPolyLine(3f, v1, v3);
        Handles.DrawAAPolyLine(3f, v0, v2);
    }
}
