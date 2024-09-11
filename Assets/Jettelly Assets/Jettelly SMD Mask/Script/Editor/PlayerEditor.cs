using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(PlayerController))]
public class PlayerEditor : Editor
{
    PlayerController _target;
    private Vector3 _oldPlayerPosition;

    private SerializedProperty _propMaskSmooth;
    private SerializedProperty _propMaskRadius;

    private void OnEnable()
    {
        _target = (PlayerController) target;

        _propMaskSmooth = serializedObject.FindProperty("MaskSmooth");
        _propMaskRadius = serializedObject.FindProperty("MaskRadius");
    }

    public override void OnInspectorGUI()
    {
        base.OnInspectorGUI();

        serializedObject.Update();
        EditorGUILayout.PropertyField(_propMaskRadius);
        EditorGUILayout.PropertyField(_propMaskSmooth);
        if (serializedObject.ApplyModifiedProperties())
        {
            _target.SetMaskPosition();
        }
    }

    private void OnSceneGUI()
    {
        if (_target.transform.position != _oldPlayerPosition)
        {
            _target.SetMaskPosition();            
        }        
        _oldPlayerPosition = _target.transform.position;
    }
}
