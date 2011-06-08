From: Brad Campbell <brad@fnarfbargle.com>
Subject: Re: Maximizing failed disk replacement on a RAID5 array
Date: Wed, 08 Jun 2011 15:32:26 +0800
Message-ID: <4DEF258A.8090600@fnarfbargle.com>
References: <BANLkTimBYFhjQ-sC9DhTMO+PG-Ox+A9S2Q@mail.gmail.com>	<BANLkTimOxCF7diZfeFgtqCBWKZVF2pxyLg@mail.gmail.com>	<BANLkTi=px08AWxfJJq+zNepCZM8aAsKECA@mail.gmail.com>	<4DECF025.9040006@fnarfbargle.com>	<BANLkTi=jPiXLySacVZqDkeThdG80K_HTxQ@mail.gmail.com>	<4DECF841.1060906@fnarfbargle.com>	<BANLkTikPxQvyDD3d_A6d3+GLKOLgqFJbFw@mail.gmail.com>	<BANLkTi=+2GFWRFKT0SCXRtkdn71msgDY=g@mail.gmail.com>	<4DEDB8B7.2070708@fnarfbargle.com> <BANLkTimxsT+htp82Us9uVgSdFNgb0m4vkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTimxsT+htp82Us9uVgSdFNgb0m4vkQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Durval Menezes <durval.menezes@gmail.com>
Cc: linux-raid@vger.kernel.org, Drew <drew.kay@gmail.com>
List-Id: linux-raid.ids

On 08/06/11 14:58, Durval Menezes wrote:

> 1) can I simply skip over these sectors (using dd_rescue or multiple
> dd invocations) when off-line copying the old disk to the new one,
> trusting the RAID5 to reconstruct the data correctly from the other 2

Noooooooooooo. As we stated early on, it you do that md will have no 
idea that the data missing is actually missing as the drive won't return 
a read error.

does a repair take long on your machine? I find that a few repair runs 
generally gets me enough re-writes to clear the dud sectors and allow an 
offline clone.

If your dd of the old disk to the new disk aborts with an error, do 
_not_ under any circumstances (well, unless you have really good 
backups) do a dd_rescue and just swap the disks.

