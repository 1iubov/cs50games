using UnityEngine;
using System.Collections;

public class CoinSpawner : MonoBehaviour {

	public GameObject[] prefabs;

	// Use this for initialization
	void Start () {

		// infinite coin spawning function, asynchronous
		StartCoroutine(SpawnCoins());
	}

	// Update is called once per frame
	void Update () {

	}

	IEnumerator SpawnCoins() {
		while (true) {

			// number of coins we could spawn vertically
			int coinsThisRow = Random.Range(1, 4);

			// instantiate all coins in this row separated by some random amount of space
			for (int i = 0; i < coinsThisRow; i++) {

				// rarity of gems 
				if (Random.Range(1,6) == 1) {
					Instantiate(prefabs[1], new Vector3(26, Random.Range(-10, 10), 10), Quaternion.identity);
				}
				//else spawn coins
				else {
					Instantiate(prefabs[0], new Vector3(26, Random.Range(-10, 10), 10), Quaternion.identity);
				}
			}

			// pause 1-5 seconds until the next coin spawns
			yield return new WaitForSeconds(Random.Range(1, 5));
		}
	}
}
