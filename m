From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Mdadm server eating drives
Date: Mon, 01 Jul 2013 20:57:57 -0500
Message-ID: <51D233A5.504@hardwarefreak.com>
References: <CAPSPcXizHpTnqfAGz7LDc3z+DSJUnOb7ukUdhbuFG6mJgs4=Bg@mail.gmail.com> <51B896A2.9090105@websitemanagers.com.au> <CAPSPcXihHrAi2TB9Fuxb1qOGMc_WzwGoXAA7nHdwe2knkO0LkQ@mail.gmail.com> <CAPSPcXib4YZ9Ah-jLvL_kPwpKHLxaGT0rNaDL4XQcFm=RtjcAQ@mail.gmail.com> <CAPSPcXhn8WKcZMVWhSDBVkRyqwo5XCyDc55f2sgr6davVsN5XA@mail.gmail.com> <51BA7B28.9030808@turmel.org> <CAPSPcXgMxOF-C2Szu_nf4ZLDC8p+yJFOtvLPu7xy1DTW9VAHjg@mail.gmail.com> <CAPSPcXh8C87whdXdzWgh97qiwLNZOjSB2OD_nxKCfmRL2GZ=Jg@mail.gmail.com> <CAPSPcXgVEEAB1UZ1R73zTRgC=VxQ8fhOwR+EJd_7bCW6D2h0fg@mail.gmail.com> <51BB8A67.5000605@turmel.org> <51BB8B86.9050803@turmel.org> <CAPSPcXi-SZjGusAtL4dj4cNNvovRcNR-uFAwAt7-9G8YRmGHkw@mail.gmail.com> <alpine.DEB.2.00.1306180609260.4696@uplift.swm.pp.se> <CAPSPcXiXo=pVfmp770==Vvj+yMU1sLMVxNf1dwCoh0At1zz3
 vQ@mail.gmail.com> <51CC72A4.4040508@jungers.net> <CAPSPcXhZosdmKiG-rhQXu+NcNJ2yLjfT1hAor1cCHWi1kM08aA@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPSPcXhZosdmKiG-rhQXu+NcNJ2yLjfT1hAor1cCHWi1kM08aA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Barrett Lewis <barrett.lewis.mitsi@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 7/1/2013 7:17 PM, Barrett Lewis wrote:
> I am very sorry to keep bugging this list, but I am really lost.

I apologize as I just noticed this thread.  If I'd jumped in sooner you
might already have it fixed.  I pulled your previous posts from my
archive folder and read with interest.

> I noticed one drive was going up and down and determined that
> the drive had actual physical damage to the power connecter and
> was losing and regaining power through vibration.

This intermittent contact could have damaged the PSU.  You've continued
to have drive and lockup problems since replacing this drive with bad
connector.

The pink elephant in the room is thermal failure due to insufficient
airflow.  The symptoms you describe sound like drives overheating.  What
chassis is this?  Make/model please.  If you've installed individual
drive hot swap cages, etc, it would be helpful if you snapped a photo or
two and made those available.

I've seen many instances of this type of failure over the years and, in
order of prevalence, they are:

1.  Failed cheap backplane
2.  Insufficient airflow
3.  Failed or cheap PSU
4.  Failed HBA (or Southbridge)

-- 
Stan

