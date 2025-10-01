using UnityEngine;

public class CameraRotateAround : MonoBehaviour
{
    [Header("Pivot Settings")]
    public Transform pivot;       // The point to rotate around
    public float rotationSpeed = 20f; // Degrees per second
    public float distance = 5f;      // Distance from pivot
    public Vector3 offset = Vector3.zero; // Extra offset if needed

    private void Start()
    {
        if (pivot != null)
        {
            // Place camera at starting position
            transform.position = pivot.position + (transform.position - pivot.position).normalized * distance + offset;
            transform.LookAt(pivot);
        }
    }

    private void Update()
    {
        if (pivot != null)
        {
            // Rotate around pivot gradually
            transform.RotateAround(pivot.position, Vector3.up, rotationSpeed * Time.deltaTime);

            // Always look at pivot
            transform.LookAt(pivot.position);
        }
    }
}