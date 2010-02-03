From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: If your using large Sata drives in raid 5/6 ....
Date: Wed, 03 Feb 2010 12:25:16 +0100
Message-ID: <87zl3qv9wj.fsf@frosties.localdomain>
References: <87f94c371002021440o3b30414bk3a7ccf9d2fa9b8af@mail.gmail.com>
	<87f94c371002021446y38dce6fds6acca2b4919ad773@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c371002021446y38dce6fds6acca2b4919ad773@mail.gmail.com>
	(Greg Freemyer's message of "Tue, 2 Feb 2010 17:46:25 -0500")
Sender: linux-raid-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Greg Freemyer <greg.freemyer@gmail.com> writes:

> All,
>
> I think the below is accurate, but please cmiiw or misunderstand.
>
> =3D=3D=3D
> If your using normal big drives (1TB, etc.) in a raid-5 array, the
> general consensus of this list is that it is a bad idea. =A0The reaso=
n being
> that the sector error rate for a bad sector has not changed with
> increasing density.
>
> So in the days of 1GB drives, the likelihood of a undetected /
> repaired bad sector was actually pretty low for the drive as whole.
> But for today's 1TB drives, the odds are 1000x worse. =A0ie. 1000x mo=
re
> sectors with the same basic failure rate per sector.

I just had such a case yesterday. It does happen too often. Esspecialy
as drives get older. Rebuilding a raid5 becomes more and more dangerous
as you increase drive capacity.

> So a raid-5 composed of 1TB drives is 1000x more likely to be unable
> to rebuild itself after a drive failure than a raid-5 built from 1 GB
> drives of yesteryear. =A0Thus the current recommendation is to use ra=
id
> 6 with high density drives.

If you can spare the drive and cpu then raid6 is definetly preferable.

Although I think the only future is in combining the raid and filesyste=
m
into one. If you have some corrupted blocks then the FS can tell you
which files are corrupted. Raid only really covers the case of a whole
drive failing well.

MfG
        Goswin
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
