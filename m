From: Phil Turmel <philip@turmel.org>
Subject: Re: upgrade to jessie/newer kernel and mdadm problems
Date: Mon, 04 May 2015 08:42:07 -0400
Message-ID: <5547691F.9060908@turmel.org>
References: <55434A08.3050505@sioban.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55434A08.3050505@sioban.net>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?SsOpcsO0bWUgVHl0Z2F0?= <jerome.tytgat@sioban.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning J=C3=A9r=C3=B4me,

On 05/01/2015 05:40 AM, J=C3=A9r=C3=B4me Tytgat wrote:
> Hello list,
>=20
> Sorry for the long post, but I wanted to be as much informative as I =
can
> be.

I was leaving your case for people who know IMSM to pipe up, as I don't
have any experience with it.  But the silence is deafening :-(

> Forgive my lack of knowlegde in mdadm, I know how to create it using =
the
> debian installer and few things to get information but that's all.
> Forgive also my english, I'm not a native in this language.

It's ok.  Your report was thorough.

> My system has been installed in 2007, and I've upgraded it several ti=
mes
> until this week to Debian Jessie (the latest version).

That explains the use of v0.90 metadata.

> So, I've upgraded my system to jessie today (only partially with apt-=
get
> upgrade + kernel upgrade) and I faced with a problem with my RAID 1 s=
oft.
>=20
> I have two disk (/dev/sdb and /dev/sdc) which are members of the raid=
 array
> There's 10 partitions on these disks, each one is a array (ie sdb1 an=
d
> sdc1).
> All of these form my raids array : md0 to md9

Understood.

> Today , one of my md partition was missing.
> Before upgrade I had partitions from md0 to md9, after reboot I'm
> missing md9.
>=20
> my mdadm.conf before reboot looked like that:

[trim /]

Very good.  Although the level=3D and num-devices=3D clauses aren't
necessary, and sometimes troublesome.

> After reboot and after a mdadm -Es, I got this:

[trim /]

>    # definitions of existing MD arrays
>    ARRAY metadata=3Dimsm UUID=3Dd9cfa6d9:2a715e4f:1fbc2095:be342429
>    ARRAY /dev/md/raidlin container=3Dd9cfa6d9:2a715e4f:1fbc2095:be342=
429
>    member=3D0 UUID=3D91449a9d:9242bfe9:d99bceb0:a59f9314

So here your system misidentified your drives as members of an
Intel-based MD-compatible hardware raid, then found raid members inside=
 it.

This is almost certainly a side effect of using v0.90 metadata.  It has
always had a design problem distinguishing between a raid partition at
the end of a disk and a raid occupying an entire device.  It's one of
the reasons that metadata was deprecated long ago.

If you haven't used the system in this weird state, fixing it should be
relatively simple:

1) use mdadm --stop on all the arrays, in numerical order.  /proc/mdsta=
t
should then be empty.

2) manually assemble your arrays, one by one, using the
--update=3Dmetadata clause to converted them to v1.0 metadata.

3) If md9 refuses to assemble (possibly damaged by the usage as IMSM),
re-create it with metadata v1.0.

4) Replace your mdadm.conf with a new scan, then update your initramfs.

However, if you've been using the system in this degraded state, you
will need to do the manual assembly with only the good partitions, then
add the other partitions to rebuild each.

Hope this helps.

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
