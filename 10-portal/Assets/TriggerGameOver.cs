using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using System.Collections;

public class TriggerGameOver : MonoBehaviour
{
    public GameObject BoxCollider;
	private Text text;
    // Start is called before the first frame update
    void Start()
    {
        text = GetComponent<Text>();

		// start text off as completely transparent black
		text.color = new Color(0, 0, 0, 0);
    }

    // Update is called once per frame
    void Update() {

    }

    void OnTriggerEnter(Collider other) {
         // reveal text only when helicopter is null (destroyed)
		text.color = new Color(0, 0, 0, 1);
		text.text = "Game Over\nPress Space to Restart!";
			
			// jump is space bar by default
		if (Input.GetButtonDown("Enter")) {;
				
			// reload entire scene
			SceneManager.LoadScene("PortalScene");
        }
    }
}


