﻿using UnityEngine;
using System.Collections;
using System.Linq;
using sugi.cc;

public class UpdateRenderTexture : MonoBehaviour
{
    public Material[] updateMats;
    [SerializeField]
    RenderTexture output;
    RenderTexture[] rts;
    public RenderTextureEvent onUpdate;

    public void SetTexture(RenderTexture rt)
    {
        output = rt;
    }

    public void UpdateRt(RenderTexture rt)
    {
        if (rts == null)
            rts = Helper.CreateRts(rt, rts);
        if (Helper.CheckRtSize(rt, rts[0]))
            rts = Helper.CreateRts(rt, rts);
        Graphics.Blit(rt, rts[0]);
        foreach (var mat in updateMats)
        {
            Graphics.Blit(rts[0], rts[1], mat);
            rts.Swap();
        }
        Graphics.Blit(rts[0], rt);
        onUpdate.Invoke(rt);
    }

    void Update()
    {
        if (output == null)
            return;
        UpdateRt(output);
    }

    void OnDestroy()
    {
        if (rts != null)
            rts.ToList().ForEach(b => Helper.ReleaseRenderTexture(b));
    }
}
