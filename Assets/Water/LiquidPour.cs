using UnityEngine;

public class LiquidPour : MonoBehaviour
{
    public Material liquidMaterial; 
    [Range(0f, 1f)] public float targetFillLevel = 0.5f; 
    public float pourSpeed = 0.5f;
    private float currentFillLevel;
    
    void Start()
    {
        if (liquidMaterial != null)
        {
            currentFillLevel = liquidMaterial.GetFloat("_FillLevel");
        }
    }
    
    void Update()
    {
        if (liquidMaterial != null)
        {
            currentFillLevel = Mathf.Lerp(currentFillLevel, targetFillLevel, Time.deltaTime * pourSpeed);
            liquidMaterial.SetFloat("_FillLevel", currentFillLevel);
        }
    }
}
