From: Mark Hills <mark-UrrBsZIrrsb10XsdtD+oqA@public.gmane.org>
Subject: Re: [mdadm PATCH] bcache: add bcache superblock
Date: Tue, 15 May 2012 22:16:42 +0100 (BST)
Message-ID: <alpine.LNX.2.01.1205152200500.13405@stax.localdomain>
References: <20120511203835.26301.1937.stgit@dwillia2-linux.jf.intel.com> <alpine.LNX.2.01.1205150042200.12473@stax.localdomain> <CABE8wwu_TXJckRXg1eSny8TnciJ6GOM_Vy7FNW1FX84YT6QZzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463793916-670150381-1337116602=:13405"
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABE8wwu_TXJckRXg1eSny8TnciJ6GOM_Vy7FNW1FX84YT6QZzQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: neilb-l3A5Bk7waGM@public.gmane.org, koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463793916-670150381-1337116602=:13405
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 15 May 2012, Dan Williams wrote:

> On Mon, May 14, 2012 at 5:04 PM, Mark Hills <mark-UrrBsZIrrsb10XsdtD+oqA@public.gmane.org> wrote:
> > On Fri, 11 May 2012, Dan Williams wrote:
> >
> >> This is a hybrid proposal for supporting bcache as a md device.
> >> Somewhat similar to the v1.x metadata format, where array assembly is
> >> handled in userspace, but managed in the kernel. =A0In the bcache case=
 it
> >> is an "external" metadata format, but then the expectation is that the
> >> kernel "bcache" personality takes over runtime maintenance of the
> >> metadata.
> >
> > I am having some trouble with this, can you clarify (perhaps by example=
)
> > how to create a pairing of a cache and backing device?
[...]
> > =A0# make-bcache -C /dev/sdb
> > =A0# make-bcache -B /dev/sdc
> > =A0# mdadm -A /dev/md0 /dev/sdb /dev/sdc
> > =A0mdadm: Cannot assemble mbr metadata on /dev/sdb
>=20
> I should have been more explicit in the changelog.  This current patch
> was only tested to assemble an existing bcache configuration.  I.e. it
> assumes the backing device has been attached to the cache set at least
> once.  By default make-bcache always creates a new cache-set id per
> invocation.  So in the above example it won't find sdb and sdc belong
> to the same md device because the cache-set id's differ.  You can
> verify this with mdadm -E.

Thanks for explaining. I suppose this is just expecially awkward at the=20
moment because attaching the devices can't be done without a different=20
kernel.

So it will be good to see the "create" support, when it is ready.

> [..]
> >
> > Maybe I missed something basic here, but I'm afraid can't see what? If
> > not, hopefully this information is useful.
> >
> > I use bcache v13 patches and the MD conversion, and this patch to mdadm=
=2E
>=20
> For reference:
>=20
> [root@fedora-virt ~]# mdadm -E /dev/vd[bc]
> /dev/vdb:
>        Magic : <bcache>
>      Version : 3
>         Role : cache
>     Set UUID : e8670bc3:974b489c:aeb68ea1:d1adf6d1
>   Cache Devs : 1
>  Device UUID : a1b25e26:5a4c4db6:2716c1aa:eba44ec7
>        Flags : sync
>       Policy : lru
>        Label :
>  Device Size : 16776192 (8.00 GiB 8.59 GB)
>  Bucket Size : 1024
>  Num Buckets : 16384
>     this dev : 0
> First Bucket : 1
>     Checksum : 45fa97cda53b0b6 correct
> /dev/vdc:
>        Magic : <bcache>
>      Version : 1
>         Role : backing-device
>     Set UUID : e8670bc3:974b489c:aeb68ea1:d1adf6d1
>   Cache Devs : 1
>  Device UUID : 7045ff87:aa4b13c4:670d8bb2:0b4ad628
>        Flags : sync
>        State : clean
>         Mode : writeback
>        Label :
>  Device Size : 16776192 (8.00 GiB 8.59 GB)
>  Bucket Size : 1024
>  Num Buckets : 16384
>     this dev : 0
> First Bucket : 1
>     Checksum : f36910e51451d91c correct

Presumably there's a little more too this, as I can't even investigate the=
=20
UIDs in use:

 =A0# make-bcache -C /dev/sdb
  [...]
 =A0# make-bcache -B /dev/sdc
  [...]
  # mdadm -E /dev/sd[bc]
  /dev/sdb:
     MBR Magic : aa55
  /dev/sdc:
     MBR Magic : aa55

I confirmed that I'm using the patched mdadm, but it still doesn't seem to=
=20
recognise the magic.

But, of course, I understand this is all work in progress. So this isn't a=
=20
complaint at all, I am just looking forward to code in this area and happy=
=20
to test where I can.

Thanks

--=20
Mark
---1463793916-670150381-1337116602=:13405--
