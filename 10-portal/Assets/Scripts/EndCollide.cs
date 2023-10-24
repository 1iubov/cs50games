using System.Collections;
using UnityEngine;
using UnityEngine.UI;

public class EndCollide : MonoBehaviour {

   public GameObject BoxCollider;
   public Text textobj;

    public string text;

    void OnTriggerEnter(Collider other) {
        // change text via Unity, it is public
        //textobj = GetComponent<Text>();
        textobj.fontSize = 80;
        textobj.text = text;
        
    }
}