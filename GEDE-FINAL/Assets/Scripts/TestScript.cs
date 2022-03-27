using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestScript : MonoBehaviour {
    public Material shade_test;
    float radius = 50f;

    // Start is called before the first frame update
    void Start() {
    }

    // Update is called once per frame
    void FixedUpdate() {
        radius = radius > 0 ? radius - 5 * Time.deltaTime : 50f;
        shade_test.SetFloat("sound_dist", radius);
    }
}