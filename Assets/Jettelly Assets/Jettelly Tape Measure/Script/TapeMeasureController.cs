using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(MeshFilter))]
[RequireComponent(typeof(MeshRenderer))]
public class TapeMeasureController : MonoBehaviour
{
    [HideInInspector] [Range(0.02f, 0.5f)] public float SetTapeWidth = 0.02f;

    [HideInInspector] public bool IsToolHidden;
    [HideInInspector] public Vector3[] Vertices;
    [HideInInspector] public int[] Triangles;
    [HideInInspector] Vector2[] UVs;
    [HideInInspector] public Vector3[] Points;
    [HideInInspector] public Material Material;

    private Mesh _mesh;
    private bool _meshInitialized = false;
    private MeshRenderer _renderer;

    [HideInInspector] public enum Measure { Meters, Centimeters, Milimeters, Inches };
    [HideInInspector] public Measure Unit = Measure.Meters;

    private float _unitValue;

    public float UnitValue 
    {
        get 
        {
            float length = Vector3.Distance(Points[0], Points[1]);

            switch (Unit)
            {
                case Measure.Meters:
                    _unitValue = length;
                    break;
                case Measure.Centimeters:
                    _unitValue = (length * 100f);
                    break;
                case Measure.Milimeters:
                    _unitValue = (length * 1000f);
                    break;
                case Measure.Inches:
                    _unitValue = (length * 39.3701f);
                    break;
            }

            return _unitValue; 
        }
    }

    private void Start()
    {
        InitMesh();
        SetMesh();
    }

    private void Reset()
    {
        InitMesh();
        SetMesh();
    }

    private TapeMeasureController()
    {
        Points = new Vector3[]
        {
             new Vector3(-1f, 0f, 0f),
             new Vector3(1f, 0f, 0f)
        };

        Vertices = new Vector3[]
        {
            new Vector3(0f, -SetTapeWidth, 0f),
            new Vector3(0f,  SetTapeWidth, 0f),
            new Vector3(0f, -SetTapeWidth, 0f),
            new Vector3(0f,  SetTapeWidth, 0f)
        };

        Triangles = new int[]
        {
            0, 1, 2,
            2, 1, 3
        };

        UVs = new Vector2[]
        {
            new Vector2(0, 0),
            new Vector2(0, 1),
            new Vector2(1, 0),
            new Vector2(1, 1)
        };
    }    

    public void SetMesh()
    {
        if (_meshInitialized)
        {
            Vector3 p0 = Points[0];
            Vector3 p1 = Points[1];

            Vector3[] vertexPosition = new Vector3[4];
            vertexPosition[0] = transform.InverseTransformPoint(LocalPosition(p0, Vertices[0]));
            vertexPosition[1] = transform.InverseTransformPoint(LocalPosition(p0, Vertices[1]));
            vertexPosition[2] = transform.InverseTransformPoint(LocalPosition(p1, Vertices[2]));
            vertexPosition[3] = transform.InverseTransformPoint(LocalPosition(p1, Vertices[3]));

            _mesh.MarkDynamic();
            _mesh.vertices = vertexPosition;
            _mesh.triangles = Triangles;
            _mesh.SetUVs(0, UVs);
            _mesh.RecalculateNormals();
            _mesh.RecalculateBounds();

#if UNITY_EDITOR
            _renderer.sharedMaterial.mainTextureScale = new Vector2(Vector3.Distance(Points[0], Points[1]) * 10, 1);
            _renderer.sharedMaterial.SetFloat("_uLength", Vector3.Distance(Points[0], Points[1]) * (20 * (0.6f - SetTapeWidth)));
            _renderer.sharedMaterial.SetPass(0);
#else
            _renderer.material.mainTextureScale = new Vector2(Vector3.Distance(Points[0], Points[1]) * 10, 1);
            _renderer.material.SetFloat("_uLength", Vector3.Distance(Points[0], Points[1])* (20 * (0.6f - SetTapeWidth)));
            _renderer.material.SetPass(0);
#endif


            Resources.UnloadUnusedAssets();
        }
        else
        {            
            InitMesh();
        }
    }    

    public void InitMesh()
    {
        if (_mesh == null)
        {
            _mesh = new Mesh();            
        }

        _meshInitialized = true;
        _renderer = GetComponent<MeshRenderer>();

#if UNITY_EDITOR
        GetComponent<MeshFilter>().sharedMesh = _mesh;        
        _renderer.sharedMaterial = Material;

#else
         GetComponent<MeshFilter>().mesh = _mesh;  
        _renderer.material = Material;
#endif

        _mesh.Clear();
    }

    public Vector3 LocalPosition(Vector3 p, Vector3 offset)
    {
        Vector3 direction = (Points[1] - Points[0]).normalized;
        float angle = Mathf.Atan2(direction.y, direction.x) * Mathf.Rad2Deg;
        Quaternion rotation = Quaternion.AngleAxis(angle, Vector3.forward);

        return transform.TransformPoint(p + rotation * offset);
    }

    private void OnGUI()
    {
        GUI.Label(new Rect(10, 10, 200, 120), "Unit Value: " + UnitValue.ToString());
    }
}
