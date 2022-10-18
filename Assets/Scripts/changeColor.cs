using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class changeColor : MonoBehaviour {
    public Material mat;
    public Color color;

	void Update () {
        mat.SetColor("_Color", color);

    }
}
