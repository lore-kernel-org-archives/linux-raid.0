Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33C7FC433F5
	for <linux-raid@archiver.kernel.org>; Wed, 26 Jan 2022 20:53:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbiAZUxa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 26 Jan 2022 15:53:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiAZUx3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 26 Jan 2022 15:53:29 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD49C06161C
        for <linux-raid@vger.kernel.org>; Wed, 26 Jan 2022 12:53:29 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id v67so1952692oie.9
        for <linux-raid@vger.kernel.org>; Wed, 26 Jan 2022 12:53:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aeoncomputing-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FIUgpCAbyTjsNWmqnpjbwfAS4S0kdlRMkgx7w8Q611k=;
        b=FWyg0WskjcL9gm3DTTQgT7L80ONk1WQlHTGNstRNE9LHAO0HYIs6+jySrRJZ0VtnTM
         vvvJVqDUk5LBngKbkK2QYQcT//E7X1ZDrZmPq3IfTbweWbHdhjzDGllqs+A1wWCqlhr3
         ByhNdu21U5FQVG9cl+l2EVzqwC9hy+R/jtD8IwpW9DtT3m1Kpa7+zRxE+/npxy2E2SdJ
         K9h4+jobiZROZVLGP55cH2lvIf7vzceQOucWuCLqj5L1P6UBW9EQC0JmE46WU+BIi2EO
         aMvYgPpCnyqGbkbQlP47aMBujfFtpbsrvyeLCFquLe/Gjk+lFmdr9yxubvyZT55BT9Mg
         Df8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FIUgpCAbyTjsNWmqnpjbwfAS4S0kdlRMkgx7w8Q611k=;
        b=rhcDUVnjz0RQioU+o57g2/ukEq7/jhL3a4/EZM5UJc298YjxbXiywGqYTIGIz0gCzS
         zZoToD1H/B/bFt2tMLDbJIyZDVeAr2Nsqyb4jKyk0TiLC7IKIa4SK+sXGNyJwUjk2HKm
         0/oR/QkppePn/FnFMmFiO1T4IlS2LckA/ZKs49tIKHWJFIMDgUVTJ2F6NLoZU6Q7pdVW
         jhVlG3sAOBekdHH1l6M3WEYdwMPWLjc0kytyweJP+OxIMsDaHnznU0PlmW5uL56Gql0r
         d94iZuFxHwwIBiA0VcnTSfXWqF97vqrVFXs+OzSHkkOBPZhxNurY+4IiHiB1aqUZhmPs
         sQNg==
X-Gm-Message-State: AOAM531Q4S2s2xfVP76qR9xajjDlNXHuANWOI0Ia/2etKP9VcB3CDsyk
        LJgE4v48r0go22wVO2gWxEd98ZFH0E3nYCg/l37K6+1AwWwZA1jbLAY=
X-Google-Smtp-Source: ABdhPJx+14nz904erFk+299iiGjRAHOWLziiS8lIkguObi6uG4+VSq2q9jIs+0cDAKSXZKLhdacftXlTlOEgcx5y/qM=
X-Received: by 2002:aca:2408:: with SMTP id n8mr262195oic.170.1643230408410;
 Wed, 26 Jan 2022 12:53:28 -0800 (PST)
MIME-Version: 1.0
References: <5EAED86C53DED2479E3E145969315A23892829E5@UMECHPA7B.easf.csd.disa.mil>
 <fade7009-48d6-356a-dc65-a66fac2d216b@sotapeli.fi> <5EAED86C53DED2479E3E145969315A2389282A56@UMECHPA7B.easf.csd.disa.mil>
In-Reply-To: <5EAED86C53DED2479E3E145969315A2389282A56@UMECHPA7B.easf.csd.disa.mil>
From:   Jeff Johnson <jeff.johnson@aeoncomputing.com>
Date:   Wed, 26 Jan 2022 12:53:17 -0800
Message-ID: <CAFCYAse8BCsTnPRSi_ivX7K8R29cKmmk-=0ZnMromWj74X-5yw@mail.gmail.com>
Subject: Re: [Non-DoD Source] Re: Showing my ignorance - kernel workers
To:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc:     "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

It might be worthwhile to check the BIOS settings on the two Rome
servers to make sure the settings match, paying particular attention
to NUMA and ioapic settings.

Background: https://developer.amd.com/wp-content/resources/56745_0.80.pdf

--Jeff

On Wed, Jan 26, 2022 at 12:40 PM Finlayson, James M CIV (USA)
<james.m.finlayson4.civ@mail.mil> wrote:
>
> Both dual socket AMD Romes.   Identical in every way.   NUMAs per socket =
set to 1 in the BIOS.   I'm using the exact same 10 drives on each system a=
nd they are PCIe Gen4 HPE OEM of SAMSUNG....
>
> -----Original Message-----
> From: Jani Partanen <jiipee@sotapeli.fi>
> Sent: Wednesday, January 26, 2022 3:32 PM
> To: Finlayson, James M CIV (USA) <james.m.finlayson4.civ@mail.mil>; linux=
-raid@vger.kernel.org
> Subject: [Non-DoD Source] Re: Showing my ignorance - kernel workers
>
> Hello, are both systems identical what comes to hardware? Mainly mobo.
>
> If no and they are dual socket systems, then it may be that one of the sy=
stems is designed to route all PCI-e via one socket so that all drive slots=
 can be used just 1 socked populated. And another is designed so taht only =
half of the drive slots works when only 1 socket is populated.
> At least I have read something like this previously from this list.
>
> // JiiPee
>
>
> Finlayson, James M CIV (USA) kirjoitti 26/01/2022 klo 22.17:
> > I apologize in advance if you can point me to something I can read abou=
t mdraid besides the source code.  I'm beyond the bounds of my understandin=
g of Linux.   Background, I do a bunch of NUMA aware computing.   I have tw=
o systems configured identically with a NUMA node 0 focused RAID5 LUN conta=
ining NUMA node 0 nvme drives  and a NUMA node 1 focused RAID5 LUN identica=
lly configured.  9+1 nvme, 128KB stripe, xfs sitting on top, 64KB O_DIRECT =
reads from the application.
>


--=20
------------------------------
Jeff Johnson
Co-Founder
Aeon Computing

jeff.johnson@aeoncomputing.com
www.aeoncomputing.com
t: 858-412-3810 x1001   f: 858-412-3845
m: 619-204-9061

4170 Morena Boulevard, Suite C - San Diego, CA 92117

High-Performance Computing / Lustre Filesystems / Scale-out Storage
