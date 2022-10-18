using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class selectNextObj : MonoBehaviour {
    public KeyCode nextKey;
    public GameObject selectableObjRoot;
    GameObject[] selectableObjs;
    GameObject currObjSelected;
    int currIndex = 0;
    Shader objSelShader, objNotSelShader;
    Material currObjSelSMat;
    public float currBorder;

	void Start () {
        selectableObjs = new GameObject[selectableObjRoot.transform.childCount];
        for (int i = 0; i < selectableObjs.Length; i++)
            selectableObjs[i] = selectableObjRoot.transform.GetChild(i).gameObject;

        objSelShader = Shader.Find("Custom/textureOutlineSelectedH");
        objNotSelShader = Shader.Find("Custom/textureH");
    }

    void Update () {
        if (Input.GetKeyDown(nextKey))
        {
            //TODO: The current selected Obj should change the shader from _textureOutline to _texture
            if (currObjSelected != null)
                currObjSelSMat.shader = objNotSelShader;
            //take change the currObjSelected
            currIndex = (currIndex + 1) % selectableObjs.Length;
            currObjSelected = selectableObjs[currIndex];
            //TODO: The next selected Obj should change the shader from _texture to _textureOutline
            currObjSelSMat = currObjSelected.GetComponent<Renderer>().material;
            currObjSelSMat.shader = objSelShader;
        }
        //if (currObjSelected != null)
            //currObjSelSMat.SetFloat("_Border", Mathf.Abs(Mathf.Sin(Time.time*2)) / 10.0f);
    }

    private void OnDestroy()
    {
        for (int i = 0; i < selectableObjs.Length; i++)
            selectableObjs[i].GetComponent<Renderer>().sharedMaterial.shader = objNotSelShader;
    }
}
