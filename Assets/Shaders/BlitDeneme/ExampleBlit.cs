using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

public class ExampleBlit : MonoBehaviour
{
    // Texture aTexture;
    private Material _material;
    public Texture _texture;
    public RenderTexture _renderTexture;
    void Start()
    {
        _material = GetComponent<MeshRenderer>().material;
    }

    // Update is called once per frame
    void Update()
    {
        Graphics.Blit(_texture, _renderTexture);
        
        _material.SetTexture( "_MainTex", _texture);
        // _material.SetTexture( "_RenderTex", _renderTexture);
    }
}
