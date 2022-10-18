using UnityEngine;

public class AutoRotate2 : MonoBehaviour
{
	public Vector3 rot;

    private void Update()
    {
        float deltaTime = Time.deltaTime;
		transform.Rotate(rot * deltaTime, Space.Self);
    }
}
