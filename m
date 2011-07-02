From: Simon Matthews <simon.d.matthews@gmail.com>
Subject: Re: Can't start array and Negative "Used Dev Size"
Date: Fri, 1 Jul 2011 21:41:53 -0700
Message-ID: <BANLkTinEcO0kh+WAU4xapWTqTqkB0ZR_KQ@mail.gmail.com>
References: <BANLkTincbuZrS3PuPBOgjidsR8jdyTGBRw@mail.gmail.com>
	<20110629151825.56cb4499@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110629151825.56cb4499@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil,

On Tue, Jun 28, 2011 at 10:18 PM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 28 Jun 2011 21:29:37 -0700 Simon Matthews
> <simon.d.matthews@gmail.com> wrote:
>
>> Problem 1: "Used Dev Size"
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> Note: the system is a Gentoo box, so perhaps I have missed a kernel
>> configuration option or use flag to deal with large hard drives.
>>
>> A week or two ago, I resized a raid1 array using 2x3TB drives. I wen=
t
>
> Oopps. =A0That array is using 0.90 metadata which can only handle up =
to 2TB
> devices. =A0The 'resize' code should catch that you are asking the im=
possible,
> but it doesn't it seems.
>
> You need to simply recreate the array as 1.0.
> i.e.
> =A0mdadm -S /dev/md5
> =A0mdadm  -C /dev/md5 --metadata 1.0 -l1 -n2 --assume-clean

Before I do this (tomorrow), do I need to add the partitions to the com=
mand:

mdadm  -C /dev/md5 --metadata 1.0 -l1 -n2 --assume-clean /dev/sdd2 /dev=
/sdc2

Simon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
