using UnityEngine;

public class CubeFloat : MonoBehaviour
{
    public float moveAmount = 0.5f;   // How far it moves
    public float moveSpeed = 2f;      // How fast it moves

    private Vector3 startPos;

    void Start()
    {
        startPos = transform.position;
    }

    void Update()
    {
        float x = Mathf.Sin(Time.time * moveSpeed) * moveAmount;
        float y = Mathf.Cos(Time.time * moveSpeed) * moveAmount;

        transform.position = startPos + new Vector3(x, y, 0f);
    }
}