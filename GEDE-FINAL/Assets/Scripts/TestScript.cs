using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestScript : MonoBehaviour {
    public Material shade_test;
    public float radius = 50f;
    public float target_radius = 50f;
    public bool has_reached_target = false;
    public GameObject player;

    // Start is called before the first frame update
    void Start() {
    }

    // Update is called once per frame
    void FixedUpdate() {
        if (!has_reached_target) {
            radius += 50 * Time.deltaTime;
            has_reached_target = radius >= target_radius;
        } else {
            radius -= 50 * Time.deltaTime;
            has_reached_target = radius > 0;
        }

        shade_test.SetFloat("sound_dist", radius);

        //Vector3 sound_pos = transform.position;

        //shade_test.SetVector("sound_pos", sound_pos);

        //shade_test.SetVector("player_pos", player.transform.position);
    }
}