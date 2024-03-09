using UnityEngine;

public class Rotate : MonoBehaviour{
    
    public float rotateSpeed = 10f;

    void Update(){
        transform.Rotate(0, rotateSpeed * Time.deltaTime, 0);
    }
}
