using UnityEngine;

public class Rotate : MonoBehaviour{
    
    // create an update function that rotates the object
    public float rotateSpeed = 10f;

    void Update(){
        transform.Rotate(0, rotateSpeed * Time.deltaTime, 0);
    }
}
