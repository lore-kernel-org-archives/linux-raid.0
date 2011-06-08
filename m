From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Maximizing failed disk replacement on a RAID5 array
Date: Wed, 08 Jun 2011 15:57:13 +0800
Message-ID: <4DEF2B59.7090408@fnarfbargle.com>
References: <BANLkTimBYFhjQ-sC9DhTMO+PG-Ox+A9S2Q@mail.gmail.com>	<BANLkTimOxCF7diZfeFgtqCBWKZVF2pxyLg@mail.gmail.com>	<BANLkTi=px08AWxfJJq+zNepCZM8aAsKECA@mail.gmail.com>	<4DECF025.9040006@fnarfbargle.com>	<BANLkTi=jPiXLySacVZqDkeThdG80K_HTxQ@mail.gmail.com>	<4DECF841.1060906@fnarfbargle.com>	<BANLkTikPxQvyDD3d_A6d3+GLKOLgqFJbFw@mail.gmail.com>	<BANLkTi=+2GFWRFKT0SCXRtkdn71msgDY=g@mail.gmail.com>	<4DEDB8B7.2070708@fnarfbargle.com>	<BANLkTimxsT+htp82Us9uVgSdFNgb0m4vkQ@mail.gmail.com>	<4DEF258A.8090600@fnarfbargle.com> <BANLkTi=4uHhNS7+WfcmvVSY11kDWe-e7ZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=4uHhNS7+WfcmvVSY11kDWe-e7ZQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Durval Menezes <durval.menezes@gmail.com>
Cc: Brad Campbell <brad@fnarfbargle.com>, linux-raid@vger.kernel.org, Drew <drew.kay@gmail.com>
List-Id: linux-raid.ids

On 08/06/11 15:47, Durval Menezes wrote:

> I'm sorry if I did not make myself clear; I've already run both a
> "repair" on the RAID  (see above) and a "smart -t long" on the
> particular disk... I had about 40 bad sectors before, and now have
> just 4, but these 4 sectors persist as being marked in error... I
> think the "RAID repair" didn't touch them.

Apologies, I obviously missed that fact.

I think your best course of action in this case is to test both the 
other drives with SMART long checks and fail/replace the faulty one.

I've never had md not report a repaired sector when performing a repair 
operation.

I'll just re-iterate, if you take the bad sectors away without a good 
copy of the data on them, md won't know it is supposed to reconstruct 
those missing sectors.

Hrm.. *or*, and this is a big *or* you could use hdparm to create 
correctable bad sectors on the copy at the appropriate LBA's, and md 
should do the right thing as it will get read errors from those, which 
will go away when they are re-written.

I'd not thought of that before, but it should do the trick.
