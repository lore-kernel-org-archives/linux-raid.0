From: Chad Walker <chad@chad-cat-lore-eddie.com>
Subject: Re: raid6 issues
Date: Sat, 18 Jun 2011 18:14:16 -0500
Message-ID: <BANLkTimXByJBzukeLrW0g8C1LM+AWyWRtg@mail.gmail.com>
References: <BANLkTi=ky+t1uM0p_HhQPScG78BFxE8Hjw@mail.gmail.com>
	<BANLkTinT48ryUV01cuveutM=mDHLzy0ggg@mail.gmail.com>
	<BANLkTimZ28GKnq41T78NfVPg8s4d9eRkfw@mail.gmail.com>
	<20110619090104.0b8c0a51@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110619090104.0b8c0a51@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Oh thank you! I guess I figured since the array was inactive, it was
stopped... rebuilding onto the spare now.

Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md1 : active raid6 sdp1[15] sdf1[0] sdb1[14] sdc1[13] sdd1[12]
sde1[11] sdj1[10] sdk1[9] sdl1[8] sdi1[7] sdm1[6] sdo1[4] sdn1[3]
sdh1[2] sdg1[1]
      25395686784 blocks level 6, 64k chunk, algorithm 2 [15/14]
[UUUUU_UUUUUUUUU]
      [>....................]  recovery =3D  0.1% (2962644/1953514368)
finish=3D1351.7min speed=3D24049K/sec

unused devices: <none>

-chad




On Sat, Jun 18, 2011 at 6:01 PM, NeilBrown <neilb@suse.de> wrote:
> On Sat, 18 Jun 2011 12:55:12 -0700 Chad Walker <chad@chad-cat-lore-ed=
die.com>
> wrote:
>
>> also output from "mdadm --assemble --scan --verbose"
>>
>> mdadm: looking for devices for /dev/md1
>> mdadm: cannot open device /dev/sdp1: Device or resource busy
>> mdadm: /dev/sdp1 has wrong uuid.
>> mdadm: cannot open device /dev/sdo1: Device or resource busy
>> mdadm: /dev/sdo1 has wrong uuid.
>> mdadm: cannot open device /dev/sdn1: Device or resource busy
>> mdadm: /dev/sdn1 has wrong uuid.
>> mdadm: cannot open device /dev/sdm1: Device or resource busy
>> mdadm: /dev/sdm1 has wrong uuid.
>> mdadm: cannot open device /dev/sdl1: Device or resource busy
>> mdadm: /dev/sdl1 has wrong uuid.
>> mdadm: cannot open device /dev/sdk1: Device or resource busy
>> mdadm: /dev/sdk1 has wrong uuid.
>> mdadm: cannot open device /dev/sdj1: Device or resource busy
>> mdadm: /dev/sdj1 has wrong uuid.
>> mdadm: cannot open device /dev/sdi1: Device or resource busy
>> mdadm: /dev/sdi1 has wrong uuid.
>> mdadm: cannot open device /dev/sdh1: Device or resource busy
>> mdadm: /dev/sdh1 has wrong uuid.
>> mdadm: cannot open device /dev/sdg1: Device or resource busy
>> mdadm: /dev/sdg1 has wrong uuid.
>> mdadm: cannot open device /dev/sdf1: Device or resource busy
>> mdadm: /dev/sdf1 has wrong uuid.
>> mdadm: cannot open device /dev/sde1: Device or resource busy
>> mdadm: /dev/sde1 has wrong uuid.
>> mdadm: cannot open device /dev/sdd1: Device or resource busy
>> mdadm: /dev/sdd1 has wrong uuid.
>> mdadm: cannot open device /dev/sdc1: Device or resource busy
>> mdadm: /dev/sdc1 has wrong uuid.
>> mdadm: cannot open device /dev/sdb1: Device or resource busy
>> mdadm: /dev/sdb1 has wrong uuid.
>>
>>
>
> Try
>
> =A0mdadm -Ss
> the the above --assemble with --force added.
>
> NeilBrown
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
