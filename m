From: NeilBrown <neilb@suse.de>
Subject: Re: [patch]raid5: fix directio regression
Date: Thu, 9 Aug 2012 11:32:30 +1000
Message-ID: <20120809113230.152aade3@notabene.brown>
References: <20120807032240.GA22495@kernel.org>
	<201208071312593120932@gmail.com>
	<CANejiEUQcA6X75WG0xSgSv6NAQaBQnwpDD-5QaNVbqmo-oqLsA@mail.gmail.com>
	<201208071421033759628@gmail.com>
	<CANejiEVoOprAFoS6mCVYDJKh+nbGE0=7Xw_CpVS+Z9AcUoh6RQ@mail.gmail.com>
	<201208081321202343795@gmail.com>
	<CANejiEWC5ZKWT2L4DM-bfGi+v=TpkABruQqe5h0qG4oQg9sDhw@mail.gmail.com>
	<201208090919591567972@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/s=RbZuYU_KncrMKNuV9OHPQ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201208090919591567972@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jianpeng Ma <majianpeng@gmail.com>
Cc: shli <shli@kernel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/s=RbZuYU_KncrMKNuV9OHPQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 9 Aug 2012 09:20:05 +0800 "Jianpeng Ma" <majianpeng@gmail.com> wrot=
e:

> On 2012-08-08 20:53 Shaohua Li <shli@kernel.org> Wrote:
> >2012/8/8 Jianpeng Ma <majianpeng@gmail.com>:
> >> On 2012-08-08 10:58 Shaohua Li <shli@kernel.org> Wrote:
> >>>2012/8/7 Jianpeng Ma <majianpeng@gmail.com>:
> >>>> On 2012-08-07 13:32 Shaohua Li <shli@kernel.org> Wrote:
> >>>>>2012/8/7 Jianpeng Ma <majianpeng@gmail.com>:
> >>>>>> On 2012-08-07 11:22 Shaohua Li <shli@kernel.org> Wrote:
> >>>>>>>My directIO randomwrite 4k workload shows a 10~20% regression caus=
ed by commit
> >>>>>>>895e3c5c58a80bb. directIO usually is random IO and if request size=
 isn't big
> >>>>>>>(which is the common case), delay handling of the stripe hasn't an=
y advantages.
> >>>>>>>For big size request, delay can still reduce IO.
> >>>>>>>
> >>>>>>>Signed-off-by: Shaohua Li <shli@fusionio.com>
> >>>> [snip]
> >>>>>>>--
> >>>>>> May be used size to judge is not a good method.
> >>>>>> I firstly sended this patch, only want to control direct-write-blo=
ck,not for reqular file.
> >>>>>> Because i think if someone used direct-write-block for raid5,he sh=
ould know the feature of raid5 and he can control
> >>>>>> for write to full-write.
> >>>>>> But at that time, i did know how to differentiate between regular =
file and block-device.
> >>>>>> I thik we should do something to do this.
> >>>>>
> >>>>>I don't think it's possible user can control his write to be a
> >>>>>full-write even for
> >>>>>raw disk IO. Why regular file and block device io matters here?
> >>>>>
> >>>>>Thanks,
> >>>>>Shaohua
> >>>> Another problem is the size. How to judge the size is large or not?
> >>>> A syscall write is a dio and a dio may be split more bios.
> >>>> For my workload, i usualy write chunk-size.
> >>>> But your patch is judge by bio-size.
> >>>
> >>>I'd ignore workload which does sequential directIO, though
> >>>your workload is, but I bet no real workloads are. So I'd like
> >> Sorry,my explain maybe not corcrect. I write data once which size is a=
lmost chunks-size * devices,in order to full-write
> >> and as possible as to no pre-read operation.
> >>>only to consider big size random directio. I agree the size
> >>>judge is arbitrary. I can optimize it to be only consider stripe
> >>>which hits two or more disks in one bio, but not sure if it's
> >>>worthy doing. Not ware big size directio is common, and even
> >>>is, big size request IOPS is low, a bit delay maybe not a big
> >>>deal.
> >> If add a acc_time for 'striep_head' to control?
> >> When get_active_stripe() is ok, update acc_time.
> >> For some time, stripe_head did not access and it shold pre-read.
> >
> >Do you want to add a timer for each stripe? This is even ugly.
> >How do you choose the expire time? A time works for harddisk
> >definitely will not work for a fast SSD.
> A time is like the size which is arbitrary.
> How about add a interface in sysfs to control by user?=20
> Only user can judge the workload, which sequatial write or random write.

This is getting worse by the minute.  A sysfs interface for this is
definitely not a good idea.

The REQ_NOIDLE flag is a pretty clear statement that no more requests that
merge with this one are expected.  If some use cases sends random requests,
maybe it should be setting REQ_NOIDLE.

Maybe someone should do some research and find out why WRITE_ODIRECT doesn't
include REQ_NOIDLE.  Understanding that would help understand the current
problem.

NeilBrown

--Sig_/s=RbZuYU_KncrMKNuV9OHPQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUCMTLznsnt1WYoG5AQLMUA/+JImj2Xfb3GG/syIzsPFdF9/CFoEwgt1X
GacfoG0Cgg1HNZJhyWhWr+iCiTjwGonvHR5MjrxKYHw5uUGYDn5HJc6Cfgcra4Jr
+SeQe9p1Qfk7pg0EY10cKCZ1XqFY7sga4sESHo/SDt98p/3WhK3fXgS5rKNiLqCS
XeRg8uH0msaW/wz0Do9d5v5ezwC2u0F+1HhtvJLojD3ejm6jjKz86yJWfbkN79hD
eLxLSIjwJh/mU5JmNr/SjUWs3u8SePs8bAB8OPU3qtmOWrd2PLmWw86yguApz+Cr
aEzJ2fMoDCndWJFqFxg0PpzlNfeQ2wx4eSonIcEDP2fuveI71/8ABAxNiteyFgTM
KkBGD3xvopCTFsBLkcvvM8g2rnb4YiEfa7KsAXtSMOaHGq0d3Jry6881lnAnmshz
Cl0336k8om25qgQJ/ZftkH8DPM+BebRL0Q4f4R+1HcJqFrN4XDTGzGQnSqKZDxcn
uQ+7pXAFX5t6AftACVjrzhZ4jlU7xBck+M71E/Fu5DPqzUg8lB1agI4w5KivfROS
n5c3JBx3ZDy4HJx1D3zFislX1VDckH9rpXLwWJuzznGggdyE+aM++8UZnZCH4Iaa
zehLZctX+vrcTi5iUDrvDQikGidrZfGJLV/tMUgNxUlxu/VSycaKMs5SaCDx1qFc
XbuQGbv/eAU=
=Pnqn
-----END PGP SIGNATURE-----

--Sig_/s=RbZuYU_KncrMKNuV9OHPQ--
