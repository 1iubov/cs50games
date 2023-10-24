using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class ScoreChange : MonoBehaviour {
    public Text textscore;
    
	// Use this for initialization
	void Start () {
        
	}
	
	// Update is called once per frame
	void Update () {
        textscore = GetComponent<Text>();
        // textscore.text = "Score : " + LevelGenerator.score.ToString();
		textscore.text = "Score : " + LevelGenerator.score.ToString();
	}
}
