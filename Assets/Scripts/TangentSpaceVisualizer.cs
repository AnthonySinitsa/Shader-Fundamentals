using UnityEngine;

public class TangentSpaceVisualizer : Monobehaviour{
    
    void OnDrawGizmos(){
        MeshFilter filter = GetComponent<MeshFilter>();
        if(filter){
            Mesh mesh = filter.sharedMesh;
            if(mesh){
                ShowTangentSpace(mesh);
            }
        }
    }

    void ShowTangentSpace(Mesh mesh){

    }
}