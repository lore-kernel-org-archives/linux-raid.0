From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: Re: question about bitmaps and dirty percentile
Date: Thu, 6 Aug 2009 08:02:39 -0500
Message-ID: <cccedfc60908060602i52403915oa7afcb38a9e386b0@mail.gmail.com>
References: <cccedfc60907301125i2187907od5819e464de2d25a@mail.gmail.com>
	<19066.30329.778572.603105@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19066.30329.778572.603105@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Aug 6, 2009 at 1:21 AM, Neil Brown<neilb@suse.de> wrote:
> On Thursday July 30, jnelson-linux-raid@jamponi.net wrote:
>>
>> I saw this, which just *can't* be right:
>>
>> md12 : active raid1 nbd0[2](W) sde[0]
>> =A0 =A0 =A0 72612988 blocks super 1.1 [3/1] [U__]
>> =A0 =A0 =A0 [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>] =A0recovery=
 =3D192.7%
>> (69979200/36306494) finish=3D13228593199978.6min speed=3D11620K/sec
>> =A0 =A0 =A0 bitmap: 139/139 pages [556KB], 256KB chunk
>
> Certainly very strange. =A0I cannot explain it at all.
>
> Please report exactly what kernel version you were running, all kerne=
l
> log messages from before the first resync completed until after the
> sync-to-200% completed.
>
> Hopefully there will be a clue somewhere in there.

Stock openSUSE 2.6.27.25-0.1-default on x86_64.

I'm pretty sure this is it:

Jul 30 13:51:01 turnip kernel: md: bind<nbd0>
Jul 30 13:51:01 turnip kernel: RAID1 conf printout:
Jul 30 13:51:01 turnip kernel:  --- wd:1 rd:3
Jul 30 13:51:01 turnip kernel:  disk 0, wo:0, o:1, dev:sde
Jul 30 13:51:01 turnip kernel:  disk 1, wo:1, o:1, dev:nbd0
Jul 30 13:51:01 turnip kernel: md: recovery of RAID array md12
Jul 30 13:51:01 turnip kernel: md: minimum _guaranteed_  speed: 1000
KB/sec/disk.
Jul 30 13:51:01 turnip kernel: md: using maximum available idle IO
bandwidth (but not more than 200000 KB/sec) for recovery.
Jul 30 13:51:01 turnip kernel: md: using 128k window, over a total of
72612988 blocks.
Jul 30 14:10:48 turnip kernel: md: md12: recovery done.
Jul 30 14:10:49 turnip kernel: RAID1 conf printout:
Jul 30 14:10:49 turnip kernel:  --- wd:2 rd:3
Jul 30 14:10:49 turnip kernel:  disk 0, wo:0, o:1, dev:sde
Jul 30 14:10:49 turnip kernel:  disk 1, wo:0, o:1, dev:nbd0


--=20
Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
