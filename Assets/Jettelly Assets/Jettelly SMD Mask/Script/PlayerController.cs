using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    [SerializeField] private MeshRenderer[] _renderer;
    [SerializeField] [Range(1.0f, 10.0f)]private float _playerSpeed = 5f;
    [HideInInspector][Range(1.0f, 5.0f)] public float MaskRadius = 2f;
    [HideInInspector][Range(0.01f, 1.0f)] public float MaskSmooth = 0.01f;

    private Vector3 _oldPlayerPosition;    
    private float _x;
    private float _y;

    // Start is called before the first frame update
    void Start()
    {
        SetMaskPosition();
    }

    // Update is called once per frame
    void Update()
    {
        _x = Input.GetAxis("Horizontal");
        _y = Input.GetAxis("Vertical");

        _x *= Time.deltaTime * _playerSpeed;
        _y *= Time.deltaTime * _playerSpeed;

        transform.Translate(new Vector3(_x, _y, 0f));

        if (transform.position != _oldPlayerPosition)
        {
            SetMaskPosition();
        }
    }

    public void SetMaskPosition()
    {
        for (int i = 0; i < _renderer.Length; i++)
        {
            if (_renderer.Length !=0 && _renderer[i] != null)
            {
                Material mat = _renderer[i].GetComponent<MeshRenderer>().sharedMaterial;
                mat.SetFloat("_X", transform.position.x);
                mat.SetFloat("_Y", transform.position.y);
                mat.SetFloat("_S", MaskSmooth);
                mat.SetFloat("_R", MaskRadius);
                _oldPlayerPosition = transform.position;
            }
        }

        Resources.UnloadUnusedAssets();
    }
}
