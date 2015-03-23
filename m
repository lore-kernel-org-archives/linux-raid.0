From: NeilBrown <neilb@suse.de>
Subject: Re: is mdadm RAID1 disk full sync
Date: Mon, 23 Mar 2015 13:52:14 +1100
Message-ID: <20150323135214.2fc67e57@notabene.brown>
References: <CAN+bsqhy0Bao1hAn3R-KtXWOjYb8O2LDo+E1jNdktWdduUL4vw@mail.gmail.com>
	<20150322142033.0af10b1a@notabene.brown>
	<CAN+bsqg2wp4VMCA8O0b2rUfbGDGXZY=mFvj1hA=tWaVkdCMXtA@mail.gmail.com>
	<20150322163809.407c6ddb@notabene.brown>
	<CAN+bsqg65AaPW1_fz=y62+7nsHNK3g1huyn3QrUEOgb-hrX=6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/REy/rTgOBYjY5WAkXGvW_xN"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAN+bsqg65AaPW1_fz=y62+7nsHNK3g1huyn3QrUEOgb-hrX=6A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: lingli tang <tanglingli001@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/REy/rTgOBYjY5WAkXGvW_xN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 22 Mar 2015 19:31:51 +0800 lingli tang <tanglingli001@gmail.com>
wrote:

> Yes, I just issue 'reboot' on Server A.

I really cannot explain that then.
If it is a completely clean "reboot" (not "reboot -f -n" for example),
then both devices should end up identical even if you weren't calling "fsyn=
c"
all the time.


> But I am curious about why 'some' request will lost to other server.
> Is It should be only one request lost(the last IO committed )
> according to full sync strategy.

Anything written since the last 'sync' or 'fsync' could be different.  How
many individual requests that is might depend on the filesystem.  But you
certainly shouldn't seem much difference, even if there is a crash.

Sorry I can't help more.

NeilBrown



>=20
> 2015-03-22 13:38 GMT+08:00 NeilBrown <neilb@suse.de>:
> > On Sun, 22 Mar 2015 13:00:54 +0800 lingli tang <tanglingli001@gmail.com>
> > wrote:
> >
> >> Thanks for reply.
> >>
> >> I have create a raid1 with two fusion io PCIe flash disk:
> >> mdadm --create /dev/md/master --name=3Dmaster --level=3D1 --raid-devic=
es=3D2
> >> /dev/fioa2 /dev/mapper/mpathc
> >> /dev/fioa2 is local disk on server A and /dev/mapper/mpathc is a iscsi
> >> load disk export from server B.
> >>
> >> After that we mkfs.ext4 on /dev/md/master and mount with 'sync' option=
 on /data1
> >> and we will run mysql binlog on it.
> >> In order to avoid data loss  of mysql binlog we have set
> >> sync_binlog=3D1. so every sql commit will call fsync() to flush to dis=
k.
> >>
> >> according to your description. if we reboot the server A, the two disk
> >> data on different server will be the same.
> >> but after the server A restarted, we assemble the two disk on two
> >> server, data is different on the two server, disk on server B lost
> >> more than one sql commit.
> >
> > What exactly do you mean by "reboot"??
> > Is this a clean shutdown or do you remove the power or something like t=
hat.
> >
> > If you remove the power, then it is very possible that some requests wi=
ll
> > have been submitted to one device but not the other.
> > If you have a clean shutdown, then the two devices should be identical.
> >
> > NeilBrown
> >
> >
> >>
> >> I have checked it with strace 'mysqld' on Server A.
> >> I found a sql commit and fsync() on binlog file handle on server A but
> >> this sql can not find in assembled disk on server B.
> >>
> >> I also test it with two SAS disk, Server B still has more than one sql
> >> commit lost.
> >>
> >>
> >> 2015-03-22 11:20 GMT+08:00 NeilBrown <neilb@suse.de>:
> >> > On Sat, 21 Mar 2015 19:01:54 +0800 lingli tang <tanglingli001@gmail.=
com>
> >> > wrote:
> >> >
> >> >> I am a newbie of mdadm. I have a question but find no answer in
> >> >> document or google for last 10 days.
> >> >>
> >> >> The question is : RAID1 made by mdadm is full sync? for example, I
> >> >> have two disk(sdb and sdc) to make RAID1 disk (/dev/md127), if I
> >> >> commit an IO to the RAID1 disk (md127), it will return back to me w=
hen
> >> >> all the two disk commit successfully      or      it will return ba=
ck
> >> >> to me once just one of the disk successfully commit.
> >> >
> >> > The write request will not return until it has been submitted to all=
, and
> >> > returned by, all working devices.
> >> >
> >> >>
> >> >> I have test with xfs and ext4 with sync option, and it seems that t=
wo
> >> >> disk have lots of commit difference after reboot the server. is that
> >> >> means mdadm return success when one of the disk is commit
> >> >> successfully?
> >> >
> >> > That certainly shouldn't happen.  I would need more details of the e=
xperiment
> >> > that you performed.
> >> >
> >> > NeilBrown
> >> >
> >> >
> >> >> --
> >> >> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> >> >> the body of a message to majordomo@vger.kernel.org
> >> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/REy/rTgOBYjY5WAkXGvW_xN
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVQ9/3jnsnt1WYoG5AQLlTxAAwA0gGJnX85O1Qnh0kbLzH0WnXl8MbBBc
ELs5B9MoWS+xP84T8HI6rTzB9zY0FVk0y7BeQrrs1lEKahVUV/P+4C+rJMtOGlL9
/83hmkgYADwsfp25WmWH0PYB2YsX6za3DE8lhdpEtPNaYbwcZEx8P5rjuejTK67f
88rLgTqPz5DLBSmUX/CHkl+mMvjMKctjhG1vN6xQIJWmI0u9b85nh79qFPJ9qIM5
3eWGkmaLjlcpVMJJak2BkHxSiVU4GlGT33E4EUyEHW6xTN7xnY9WlVogpbXvmqg+
CJc3ctMKBfKB+4k6Vv0Qc8sLngVW5QEWEullCV0E/YshUc3RTLQbwIPnC0W39nsp
4dX8a4WKU6c5xjEVDdI2YpWF1jirkXzMNsP2UnfVGXdlgzgCn0udBtQkKq92JjrU
PtsCuyayfF5/cXZgH8zdFAamVH88xDzgvhs+0Gx7sTldxK5WdVHxmTd+yK1TyPlG
Fx+0s+VR4WuqekFG8UEHUjnuzrcePB1cudxAEOSzZ+9mpIp7qHknttwMYsunuquE
oaUdTlu9xs8Jd4Nr5N6iEGK61OBCd47ps+e6Ks0fpBs0C8K3Cgi6DMb6P9VDR9tB
JJUivcwAEtuM/FzJzlUX/l+kbgY++z7GfXUEyUPfSVtozr5FtyDGJkvYQ1qElDwK
ZAtEfCM4d2c=
=W2Wd
-----END PGP SIGNATURE-----

--Sig_/REy/rTgOBYjY5WAkXGvW_xN--
