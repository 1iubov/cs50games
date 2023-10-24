using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class LoadSceneOnInput : MonoBehaviour {

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetAxis("Submit") == 1) {
			SceneManager.LoadScene("Play");
			var wisper = DontDestroy.instance.GetComponents<AudioSource>()[0];    
            wisper.Play();  
		}
	}
}
