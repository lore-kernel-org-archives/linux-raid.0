From: NeilBrown <neilb@suse.de>
Subject: Re: /dev/md0 can't be created
Date: Wed, 25 Mar 2015 17:35:29 +1100
Message-ID: <20150325173529.13a6efd7@notabene.brown>
References: <1215809785.2787621.1427263359309.JavaMail.zimbra@redhat.com>
	<12135556.2792023.1427264134774.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/R5bj/z+uC5WJN+.Ob0NSvq."; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <12135556.2792023.1427264134774.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/R5bj/z+uC5WJN+.Ob0NSvq.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 25 Mar 2015 02:15:34 -0400 (EDT) Xiao Ni <xni@redhat.com> wrote:

> Hi all
>=20
>    I have encountered so many times, the raid device is created successfu=
lly, but the directory
> /dev/md0 can't be created. It can't reproduce 100%.=20
>=20
> [root@intel-sugarbay-do-01 create_assemble]# cat /proc/mdstat=20
> Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]=20
> md0 : active raid10 loop7[7](S) loop6[6] loop5[5] loop4[4] loop3[3] loop2=
[2] loop1[1] loop0[0]
>       1788416 blocks super 1.2 512K chunks 2 near-copies [7/7] [UUUUUUU]
>       bitmap: 0/1 pages [0KB], 65536KB chunk
>=20
> unused devices: <none>
> [root@intel-sugarbay-do-01 create_assemble]# ls /dev/md0
> ls: cannot access /dev/md0: No such file or directory
>=20
>     The underline devices are loop devices which are created with big fil=
e.
>=20
>     The kernel I used is RHEL7 (3.10.0-234.el7.x86_64.debug, mdadm - v3.3=
.2 - 21st August 2014)=20
> I'll try to reproduce this with upstream kernel and mdadm. But I think it=
 shouldn't be the problem about kernel.
>=20
>     What do you think I should check for this? And which tool is responsi=
ble for creating the directory? Maybe
> I can add some log to it to find the reason.
>=20

/dev/md0 is created by udev.
Run
  udevadm monitor

to see the events that udev is processing.  When and ADD event for "md0" is
processed, /dev/md0 should get created.

NeilBrown

--Sig_/R5bj/z+uC5WJN+.Ob0NSvq.
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVRJXMTnsnt1WYoG5AQLCzg/+N7XIMeYoTzRWd5219GM5/yHLk9oPaR/L
mALBN9BSYFmpuuAavRYLA8OgT2hApnJNQ3/KCIKP3BZhk5shiuOUlJp0KV+eR+RE
/m5HH9rSIdjpAGDQ/5QYTXuTD5I1EeSCzgssgjjmDvQr2eK87wqSMeAceJXqUari
gv3PzoxcA4KsV8vhR15EzSICymv9Vqcr//lvWL+DbLwkmT9BchFu+H98Mww9IMWe
Dy5JteT8nGlWOpvY4X0tORVgFVk4Jjcjt0eUM9z+FFk7cnMB8+SDOKQKT+ZMmWli
MjaHGA/q0AYb26X8odSc+yPelRk/3aGNaQD2flZou4bLOIq5BYEXIGsKsRqybx1Y
pq4raqiBd7b+ueHfnTqXn9cPl2mKzlosdXW/1rPv5I62OmkR9AY89i5KPyxoru2N
UMQUqQ4l14S98xgjblzL+vXDvwLp4P/ZJLaZC2wzBGG/wiUsQlrQF5EfNxJur79Q
XPo+QpsWmGRmUYvbU06VKAIj6YkCCoxvxBhqnqCnAyYGynIsjlJmyirwj8u9qCRm
84/GFWDo73AHuhbRNF3lGCu25S/omS3gm2UzgHUG8cBakDai1MGY6oHCrp8Zermp
ezfsKjh/4k1B21aGCu/gex+8RWAqZwdnb+rPV930xreziRor8kq4cN3i7FKayTEX
9b1C3ncMsQk=
=uNyP
-----END PGP SIGNATURE-----

--Sig_/R5bj/z+uC5WJN+.Ob0NSvq.--
