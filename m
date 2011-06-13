From: Durval Menezes <durval.menezes@gmail.com>
Subject: Re: Maximizing failed disk replacement on a RAID5 array
Date: Mon, 13 Jun 2011 02:56:47 -0300
Message-ID: <BANLkTin58zxkr1GRut+kZTSe3RmAfFZbug@mail.gmail.com>
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
	<BANLkTi=4uHhNS7+WfcmvVSY11kDWe-e7ZQ@mail.gmail.com>
	<4DEF2B59.7090408@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DEF2B59.7090408@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: Brad Campbell <brad@fnarfbargle.com>, linux-raid@vger.kernel.org, Drew <drew.kay@gmail.com>
List-Id: linux-raid.ids

Hello Brad, folks,

On Wed, Jun 8, 2011 at 4:57 AM, Brad Campbell <lists2009@fnarfbargle.co=
m> wrote:
> On 08/06/11 15:47, Durval Menezes wrote:
>
>> I'm sorry if I did not make myself clear; I've already run both a
>> "repair" on the RAID =A0(see above) and a "smart -t long" on the
>> particular disk... I had about 40 bad sectors before, and now have
>> just 4, but these 4 sectors persist as being marked in error... I
>> think the "RAID repair" didn't touch them.
[...]
> I've never had md not report a repaired sector when performing a repa=
ir
> operation.

Just to keep you posted: after I finished replacing that failing disk,
I wrote zeroes to all its sectors (dd bs=3D16065b </dev/zero >/dev/DISK=
)
and then checked SMART again.

Guess what? As expected, the 4 sectors that were being reported in
both "Current_Pending_Sector" and "Offline_Uncorrectable" just went
away... both counters now report a big round  "0".

So, it seems my hypothesis that these sectors were not being touched
by the md "repair" was indeed correct: once they were written to, they
ended up being automatically remapped (or at least cleaned out of the
above counters) by the HD firmware. Also, as the array resync reported
no errors whatsoever, it seems these sectors were simply not being
used by md.

Anyone has a good explanation to that? Inquiring minds want to know... =
:-)

Cheers,
--=20
   Durval Menezes.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
