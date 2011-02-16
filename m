From: "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>
Subject: RE: Single-drive RAID0
Date: Wed, 16 Feb 2011 16:57:06 +0000
Message-ID: <BE2BFE91933D1B4089447C644860408069028F47@irsmsx503.ger.corp.intel.com>
References: <BE2BFE91933D1B4089447C644860408067197930@irsmsx503.ger.corp.intel.com>
	<20110209134557.4e607451@notabene.brown>
	<BE2BFE91933D1B4089447C644860408068C4429D@irsmsx503.ger.corp.intel.com>
	<20110214131149.7f0655a3@notabene.brown>
	<BE2BFE91933D1B4089447C644860408068FB2C6E@irsmsx503.ger.corp.intel.com>
	<20110215110141.30d28302@notabene.brown>
	<BE2BFE91933D1B4089447C644860408068FB347B@irsmsx503.ger.corp.intel.com>
 <20110216114234.0311d27b@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_BE2BFE91933D1B4089447C644860408069028F47irsmsx503gercor_"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110216114234.0311d27b@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--_002_BE2BFE91933D1B4089447C644860408069028F47irsmsx503gercor_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable



> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Wednesday, February 16, 2011 1:43 AM
> To: Wojcik, Krzysztof
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Single-drive RAID0
>=20
> On Tue, 15 Feb 2011 16:30:05 +0000 "Wojcik, Krzysztof"
> <krzysztof.wojcik@intel.com> wrote:
>=20
> > > It might help to put a "WARN_ON(1)" in the place where it prints
> > > "detected
> > > capacity change ..." so we get a stack trace and can see how it got
> > > there.
> > > That might git a hint to what is looping.
> > > Also a printk in md_open if it returns ERESTARTSYS would be
> > > interesting.
> >
> > In attachment part of logs from kernel with WARN_ON(1) and value
> returned by md_open()
> > (line preceded with "##### KW: err=3D x").
> >
> > I am trying to look for in new areas. I've run:
> > Udevd --debug --dedug-traces
> >
> > Logs from udev and kernel in attachment.
> > Maybe it will help to find solution...
> > It seems to udev adds and removes device in loop...
>=20
> Thanks for the extra logs.... it helps a bit, but I'm not a lot closer.
>=20
> I've seen something a little bit like this which was fixed by adding
>=20
> TEST!=3D"md/array_state", GOTO=3D"md_end"
>=20
> just after
>=20
> # container devices have a metadata version of e.g. 'external:ddf' and
> # never leave state 'inactive'
>=20
> in /lib/udev/rules.d/64-md-raid.rules
>=20
>=20
> Could you try that??

I tried. It not helps :(

>=20
> It looks like the 'bdev' passed to md_open keeps changing, which it
> shouldn't.
>=20
> If the above doesn't help, please add:
>=20
> 	printk("bdev=3D%p, mddev=3D%p, disk=3D%p dev=3D%x\n", bdev, mddev, mddev=
-
> >gendisk, bdev->bd_dev);
>=20
> at the top of 'md_open', and see what it produces.

I tried this also but I can't see any useful information that can make me s=
ome idea.
Could you look at logs in attachment?

Regards
Krzysztof

>=20
> Thanks,
> NeilBrown


--_002_BE2BFE91933D1B4089447C644860408069028F47irsmsx503gercor_
Content-Type: application/x-compressed; name="kernel_log.tgz"
Content-Description: kernel_log.tgz
Content-Disposition: attachment; filename="kernel_log.tgz"; size=1830;
	creation-date="Wed, 16 Feb 2011 16:53:43 GMT";
	modification-date="Wed, 16 Feb 2011 16:51:48 GMT"
Content-Transfer-Encoding: base64

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
mnMAoAAA

--_002_BE2BFE91933D1B4089447C644860408069028F47irsmsx503gercor_--
