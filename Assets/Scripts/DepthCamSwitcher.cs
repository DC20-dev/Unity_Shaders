using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum camRT { off, depth, normals, motionv};
public class DepthCamSwitcher : MonoBehaviour {
    public Camera cam;
    public camRT RT_Type;

	void Update () {
        //A camera can build a screen-space depth texture. This is mostly useful for image post-processing effects
        if(RT_Type == camRT.off)
            cam.depthTextureMode = DepthTextureMode.None;
        else if (RT_Type == camRT.depth)
            cam.depthTextureMode = DepthTextureMode.Depth;
        else if (RT_Type == camRT.normals)
            cam.depthTextureMode = DepthTextureMode.DepthNormals;
        else if (RT_Type == camRT.motionv)
            cam.depthTextureMode = DepthTextureMode.MotionVectors;
    }
}
