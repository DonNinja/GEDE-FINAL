using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestScript : MonoBehaviour {
    public Material outline_mat;
    public float radius = 50f;
    public float target_radius = 50f;
    public bool has_reached_target = false;
    public bool pulse;
    public AudioSource pulse_audio;

    // Start is called before the first frame update
    void Start() {
    }

    // Update is called once per frame
    void FixedUpdate() {
        if (pulse) {
            if (!has_reached_target) {
                if (pulse_audio && !pulse_audio.isPlaying) {
                    pulse_audio.Play();
                }
                radius += 50 * Time.deltaTime;
                has_reached_target = radius >= target_radius;
            }
            else {
                radius -= 5 * Time.deltaTime;
                has_reached_target = radius > 0;
            }

            outline_mat.SetFloat("sound_dist", radius);
        }
    }
}