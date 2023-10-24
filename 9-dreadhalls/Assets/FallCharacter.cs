using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;


public class FallCharacter : MonoBehaviour {


    void Start() {

    }
    void Update() {
        // on fps controller gameobject
        var ycharacter = transform.position.y;
        if (ycharacter < -5f) {
            // scene Game Over
            SceneManager.LoadScene("GameOver");  
            // stop music    
            var wisper = DontDestroy.instance.GetComponents<AudioSource>()[0];    
            wisper.Stop();  
            // score is null
            LevelGenerator.score = 0;
        }
    }
}