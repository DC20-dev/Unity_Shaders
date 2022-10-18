using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CoordSpaces : MonoBehaviour {
    public Camera cam;
    Vector3 worldSpace      = new Vector3();
    Vector3 viewSpace       = new Vector3();
    Vector4 projSpace       = new Vector4();
    Vector3 ndcSpace        = new Vector3();   
    Vector2 textureSpace    = new Vector2();

	void Update () {
        Matrix4x4 worldSpaceMatrix = transform.localToWorldMatrix;
        Matrix4x4 viewMatrix       = cam.worldToCameraMatrix;
        Matrix4x4 projMatrix       = cam.projectionMatrix;

        /*
         * To test the position of our transform in Worldspace, ViewSpace, ProjectionSpace, etc.. we start from
         *  ObjectSpace.
         * The vertex we are going to trannform is the object center, which has (0,0,0) vertex coords.
         * For our first transformation we are multiplying a WorldSpaceMatrix for a column vector (0,0,0,1)
         *  and the result is:
         * |m_00 m_01 m_02 m_03| |0|   |m_03|
         * |m_10 m_11 m_12 m_13| |0| = |m_13|
         * |m_20 m_21 m_22 m_23| |0|   |m_23|
         * |m_30 m_31 m_32 m_33| |1|   |1   |
         * This is why we can look directly at WS_m.m03, WS_m.m13, WS_m.m23) values to know the vertex position
         *  in WorldSpace, and from WorldSpace on, the explanation is the same.
         */
        Matrix4x4 WS_m = worldSpaceMatrix;
        worldSpace = new Vector3(WS_m.m03, WS_m.m13, WS_m.m23);
        Matrix4x4 VS_m = viewMatrix * worldSpaceMatrix;
        viewSpace = new Vector3(VS_m.m03, VS_m.m13, VS_m.m23);
        Matrix4x4 PS_m = projMatrix * viewMatrix * worldSpaceMatrix;
        projSpace = new Vector4(PS_m.m03, PS_m.m13, PS_m.m23, PS_m.m33);
        ndcSpace = new Vector4(PS_m.m03/PS_m.m33, PS_m.m13 / PS_m.m33, PS_m.m23 / PS_m.m33, PS_m.m33 / PS_m.m33);
        textureSpace.x = (ndcSpace.x + 1) * 0.5f;
        textureSpace.y = (ndcSpace.y + 1) * 0.5f;

        Debug.Log("World Position : " + worldSpace);
        Debug.Log("View Position : " + viewSpace);
        Debug.Log("Projection Position : " + projSpace);
        Debug.Log("NDC Position : " + ndcSpace);
        Debug.Log("Texture Position : " + textureSpace);
    }
}
