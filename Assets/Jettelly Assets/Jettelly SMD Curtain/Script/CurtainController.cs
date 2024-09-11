using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class CurtainController : MonoBehaviour
{
    public enum CurtainMode { OPENING, CLOSING }
    public CurtainMode Mode = CurtainMode.OPENING;   

    [SerializeField] 
    [Range(2, 6)] private int _fadeLength = 4;

    private float _secondsToLoadNextScene = 0.5f;
    private float _time = 0f;
    private Material _material;   
    
    void Start()
    {
        StartCoroutine(TriggerCurtainAnimation());
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            _time = 0f;
            Mode = CurtainMode.CLOSING;
            StartCoroutine(TriggerCurtainAnimation());
        }
    }    

    IEnumerator TriggerCurtainAnimation()
    {       
        int length = 10 * _fadeLength;

        for (int i = 0; i < length; i++)
        {
            _time += (1f / length);
            yield return new WaitForSeconds(0.0f); 
            float v = Mathf.Lerp(0.15f, -2.4f, _time);
            SetCurtainMode(Mode);
            _material.SetFloat("_Edge", v);
        }

        if (Mode == CurtainMode.CLOSING)
        {
            yield return new WaitForSeconds(_secondsToLoadNextScene);
            int y = SceneManager.GetActiveScene().buildIndex;
            SceneManager.LoadScene((y + 1) % SceneManager.sceneCountInBuildSettings, LoadSceneMode.Single);
        }        
    }

    private void SetCurtainMode(CurtainMode mode)
    {
        if (_material == null)
        {
            _material = GetComponent<RawImage>().material;
        }       

        switch (mode)
        {
            case CurtainMode.OPENING:
                _material.EnableKeyword("_MODE_OPENING");
                _material.DisableKeyword("_MODE_CLOSING");
                break;
            case CurtainMode.CLOSING:
                _material.EnableKeyword("_MODE_CLOSING");
                _material.DisableKeyword("_MODE_OPENING");
                break;
        }
    }
}
