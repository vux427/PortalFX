using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FPS : MonoBehaviour {

    const int sampleCount = 60;
    [SerializeField] int[] fpsData = new int[sampleCount];
    int index;

    public Transform cos;


    int highestFPS;
    int averageFPS;
    int lowestFPS = int.MaxValue;

    const float updateTime = .5f;
    float currentTime;

    void Start () {
		
	}

    void Update()
    {
        currentTime += Time.deltaTime;
        //caculate fps
        fpsData[index++ % sampleCount] = (int)(1f / Time.unscaledDeltaTime);

        if (currentTime < updateTime) return;
        else currentTime = 0;
        //reset fps data
        if (index >= sampleCount)
        {
            //index = 0;
            highestFPS = 0;
            lowestFPS = int.MaxValue;
        }
        int sum = 0;
        for (int i = 0; i < sampleCount; i++)
        {
            sum += fpsData[i];
            if (fpsData[i] > highestFPS)
                highestFPS = fpsData[i];
            if (fpsData[i] < lowestFPS)
                lowestFPS = fpsData[i];
        }
        averageFPS = sum / sampleCount;
    }

    void OnGUI()
    {
        GUILayout.BeginArea(new Rect(0, 0, 150, 120));
        GUI.color = Color.green;
        GUILayout.Label(string.Format("Highest FPS:{0}", highestFPS));

        GUI.color = Color.yellow;
        GUILayout.Label(string.Format("Average FPS:{0}", averageFPS));

        GUI.color = Color.red;
        GUILayout.Label(string.Format("Lowest FPS:{0}", lowestFPS));

        GUILayout.EndArea();
    }
}
