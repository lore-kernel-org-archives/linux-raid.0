From: Durval Menezes <durval.menezes@gmail.com>
Subject: Re: Maximizing failed disk replacement on a RAID5 array
Date: Wed, 8 Jun 2011 04:47:11 -0300
Message-ID: <BANLkTi=4uHhNS7+WfcmvVSY11kDWe-e7ZQ@mail.gmail.com>
References: <BANLkTimBYFhjQ-sC9DhTMO+PG-Ox+A9S2Q@mail.gmail.com>
	<BANLkTimOxCF7diZfeFgtqCBWKZVF2pxyLg@mail.gmail.com>
	<BANLkTi=px08AWxfJJq+zNepCZM8aAsKECA@mail.gmail.com>
	<4DECF025.9040006@fnarfbargle.com>
	<BANLkTi=jPiXLySacVZqDkeThdG80K_HTxQ@mail.gmail.com>
	<4DECF841.1060906@fnarfbargle.com>
	<BANLkTikPxQvyDD3d_A6d3+GLKOLgqFJbFw@mail.gmail.com>
	<BANLkTi=+2GFWRFKT0SCXRtkdn71msgDY=g@mail.gmail.com>
	<4DEDB8B7.2070708@fnarfbargle.com>
	<BANLkTimxsT+htp82Us9uVgSdFNgb0m4vkQ@mail.gmail.com>
	<4DEF258A.8090600@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DEF258A.8090600@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@fnarfbargle.com>
Cc: linux-raid@vger.kernel.org, Drew <drew.kay@gmail.com>
List-Id: linux-raid.ids

Hello Brad,

On Wed, Jun 8, 2011 at 4:32 AM, Brad Campbell <brad@fnarfbargle.com> wrote:
> On 08/06/11 14:58, Durval Menezes wrote:
>
>> 1) can I simply skip over these sectors (using dd_rescue or multiple
>> dd invocations) when off-line copying the old disk to the new one,
>> trusting the RAID5 to reconstruct the data correctly from the other 2
>
> Noooooooooooo. As we stated early on, it you do that md will have no idea
> that the data missing is actually missing as the drive won't return a read
> error.

Even if a "repair" (echo "repair" >/sys/block/md1/md/sync_status,
checking progress with "cat /proc/mdstat" and completion with "tail -f
/var/log/messages | grep md" ) finishes with no errors?

> does a repair take long on your machine? I find that a few repair runs
> generally gets me enough re-writes to clear the dud sectors and allow an
> offline clone.

I'm sorry if I did not make myself clear; I've already run both a
"repair" on the RAID  (see above) and a "smart -t long" on the
particular disk... I had about 40 bad sectors before, and now have
just 4, but these 4 sectors persist as being marked in error... I
think the "RAID repair" didn't touch them.

Cheers,
-- 
  Durval.
