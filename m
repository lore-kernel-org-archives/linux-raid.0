From: Christian <cjs703@gmail.com>
Subject: Re: RAID6 array won't start
Date: Fri, 11 Feb 2011 16:13:53 -0500
Message-ID: <AANLkTikmCmutS_96PNYR0RKAv07cG5Vje0kyzzQ7U9rd@mail.gmail.com>
References: <AANLkTimLfJHc2waPkvjUXn=mewc37qkCd-r0GG4k=e-D@mail.gmail.com>
	<AANLkTi=dtMbuszU3x_hGduN-y5ATbgD0tgby_2mj4YsH@mail.gmail.com>
	<20110212074904.41e113ed@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110212074904.41e113ed@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Feb 11, 2011 at 3:49 PM, NeilBrown <neilb@suse.de> wrote:
> On Fri, 11 Feb 2011 11:48:41 -0500 Christian <cjs703@gmail.com> wrote=
:
>
>> Hello,
>>
>> I have a 10 disk RAID6 array.=A0 I had an issue with a molex connect=
or
>> that caused drives to drop from a 5in3 SATA backplane.=A0 There wasn=
't
>> any activity occurring on the array during the time, so I think the
>> filesystem should be in tact.=A0 The issue now is the event counts a=
re
>> out of sync, along with the state of each drive.
>>
>> # mdadm -A /dev/md1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdk1 /dev/sdl=
1
>> /dev/sdm1 /dev/sdq1 /dev/sdr1 /dev/sds1 /dev/sdt1
>> mdadm: /dev/md1 assembled from 8 drives - not enough to start the
>> array while not clean - consider --force.
>>
>> # cat /proc/mdstat
>> Personalities : [raid6] [raid5] [raid4]
>> md1 : inactive sdt1[1](S) sde1[9](S) sdl1[8](S) sdg1[7](S) sdf1[6](S=
)
>> sdk1[5](S) sdq1[4](S) sds1[3](S) sdr1[2](S) sdm1[0](S)
>> =A0=A0=A0=A0=A0 19535134720 blocks
>>
>>
>> # mdadm -Af /dev/md1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdk1 /dev/sd=
l1
>> /dev/sdm1 /dev/sdq1 /dev/sdr1 /dev/sds1 /dev/sdt1
>> mdadm: failed to RUN_ARRAY /dev/md1: Input/output error
>
> The array is already in a partially-assembled state.
>
> mdadm -S /dev/md1
>
> before trying to assemble again with -f.
>
> NeilBrown

I should have probably included it but I did stop the array with -S
before running -Af.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
