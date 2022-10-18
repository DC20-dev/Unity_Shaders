using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShaderReplacer : MonoBehaviour {
    public Shader fxShader;

    public string replaceObjectsWithTag;
    public bool applyFx, resetFx;
    public Camera cam;

	void Update () {
        if (applyFx)
        {
            applyFx = false;
            cam.SetReplacementShader(fxShader, replaceObjectsWithTag);
        }
        if (resetFx)
        {
            resetFx = false;
            cam.ResetReplacementShader();
        }
    }
}
