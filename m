From: NeilBrown <neilb@suse.de>
Subject: Re: Bugreport ddf rebuild problems
Date: Thu, 8 Aug 2013 10:40:56 +1000
Message-ID: <20130808104056.35e797ca@notabene.brown>
References: <51FAB74B.4030200@gmail.com>
	<51FAB282.6040303@arcor.de>
	<CAGkViCFT0+qm9YAnAJM7JGgVg0RTJi8=HAYDTMs-mfhXinqdcg@mail.gmail.com>
	<51FACF7C.50400@arcor.de>
	<51FADCA5.1080801@arcor.de>
	<51FAE319.6030604@arcor.de>
	<51FCD0BB.1040402@gmail.com>
	<51FE234A.4060808@gmail.com>
	<51FFD913.1090301@gmail.com>
	<5200180C.6060604@arcor.de>
	<20130806101633.4b8f2374@notabene.brown>
	<52016A06.8070400@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/v8w4PBLsZa5Z./r.XPituf8"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52016A06.8070400@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: Albert Pauw <albert.pauw@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/v8w4PBLsZa5Z./r.XPituf8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 06 Aug 2013 23:26:30 +0200 Martin Wilck <mwilck@arcor.de> wrote:

> On 08/06/2013 02:16 AM, NeilBrown wrote:
> > On Mon, 05 Aug 2013 23:24:28 +0200 Martin Wilck <mwilck@arcor.de> wrote:
> >=20
> >> Hi Albert, Neil,
> >>
> >> I just submitted a new patch series; patch 3/5 integrates your 2nd case
> >> as a new unit test and 4/5 should fix it.
> >>
> >> However @Neil: I am not yet entirely happy with this solution. AFAICS
> >> there is a possible race condition here, if a disk fails and mdadm -CR
> >> is called to create a new array before the metadata reflecting the
> >> failure is written to disk. If a disk failure happens in one array,
> >> mdmon will call reconcile_failed() to propagate the failure to other
> >> already known arrays in the same container, by writing "faulty" to the
> >> sysfs state attribute. It can't do that for a new container though.
> >>
> >> I thought that process_update() may need to check the kernel state of
> >> array members against meta data state when a new VD configuration reco=
rd
> >> is received, but that's impossible because we can't call open() on the
> >> respective sysfs files. It could be done in prepare_update(), but that
> >> would require major changes, I wanted to ask you first.
> >>
> >> Another option would be changing manage_new(). But we don't seem to ha=
ve
> >> a suitable metadata handler method to pass the meta data state to the
> >> manager....
> >>
> >> Ideas?
> >=20
> > Thanks for the patches - I applied them all.
>=20
> I don't see them in the public repo yet.
>=20
> > Is there a race here?  When "mdadm -C" looks at the metadata the device=
 will
> > either be an active member of another array, or it will be marked fault=
y.
> > Either way mdadm won't use it.
>=20
> That's right, thanks.
>=20
> > If the first array was created to use only (say) half of each device an=
d the
> > second array was created with a size to fit in the other half of the de=
vice
> > then it might get interesting.
> > "mdadm -C" might see that everything looks good, create the array using=
 the
> > second half of that drive that has just failed, and give that info to m=
dmon.
>=20
> Yes, I have created a test case for this (10ddf-fail-create-race) which
> I am going to submit soon.
>=20
> > I suspect that ddf_open_new (which currently looks like it is just a st=
ub)
> > needs to help out here.
>=20
> Great idea, I made an implementation. I found that I needed to freeze
> the array in Create(), too, to avoid the kernel starting a rebuild
> before the mdmon checked the correctness of the new array. Please review
> that, I'm not 100% positive I got it right.
>=20
> > When manage_new() gets told about a new array it will collect relevant =
info
> > from sysfs and call ->open_new() to make sure it matches the metadata.
> > ddf_open_new should check that all the devices in the array are recorde=
d as
> > working in the metadata.  If any are failed, it can write 'faulty' to t=
he
> > relevant state_fd.
> >=20
> > Possibly the same thing can be done generically in manage_new() as you
> > suggested.  After the new array has been passed over to the monitor thr=
ead,
> > manage_new() could check if any devices should be failed much like
> > reconcile_failed() does and just fail them.
> >=20
> > Does that make any sense?  Did I miss something?
>=20
> It makes a lot of sense.
>=20
> While testing, I found another minor problem case:
>=20
>  1 disk fails in array taking half size
>  2 mdmon activates spare
>  3 mdadm -C is called and finds old meta data, allocates extent at
> offset 0 on the spare
>  4 Create() gets an error writing to the "size" sysfs attribute because
> offset 0 has been grabbed by the spare recovery already
>=20
> That's not too bad, after all, because the array won't be created. The
> user just needs to re-issue his mdadm -C command which will now succeed
> because the meta data should have been written to disk in the meantime.
>=20
> That said, some kind of locking between mdadm and mdmon (mdadm won't
> read meta data as long as mdmon is busy writing them) might be
> desirable. It would be even better to do all meta data operations
> through mdmon, mdadm just sending messages to it. That would be a major
> architectural change for mdadm, but it would avoid this kind of
> "different meta data here and there" problem altogether.

I think the way this locking "should" happen is with an O_EXCL lock on the
container.
mdadm and mdmon already do this to some extent, but it is hard to find :-)

The most obvious usage is that mdmon insists on getting an O_EXCL open befo=
re
it will exit.  --create also gets an O_EXCL open, so mdmon cannot
exit while a new array might be being created.
See "When creating a member, we need to be careful" in Create.c and
" No interesting arrays, or we have been told to" in monitor.c

So this race could be closed by manager getting an O_EXCL open on the
container before performing spare management.

Thanks,
NeilBrown

--Sig_/v8w4PBLsZa5Z./r.XPituf8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUgLpGDnsnt1WYoG5AQIFpg//cCQs0RhUNo2ijjcqscnwiHquMKM7p897
VUFNlGldfB53wUaiEQBOUijpUaNLzZHyfsl6QqAZSgFRKrQtIyev+XSmuGPwcIwc
CwWWbhY6pTnoEOIu/Itvbs0Y8UDJrFN8irQ2twZ8jHT8oRfgUhcXmLs5WWUdo4E2
qOqD3FOJsC+vzPOoyE1GATxQDmCppX0DS52SMmW1aR22Kg8DLc7qnrYIkq54w11j
T+oYminECGYjWdu8YzSck5SXLzl9Yv8OxeOvdqm+0et5y5fcZAvJ6Q4Pua03Pvyt
ky3L62jwRbmsA5fZvhbOH3UHeJm+xX3e671U5eFwUCxLswjeC9yTDZr2BfmfewFW
ioXpwrZ9584mc++YhGiF5PYGtthVsFvmQtR8Z0IiIoPAWyFwd2uKd5uVH0IFZwdN
gEno0G/pY19k8awAmqZOOfkTYu/wB4rxEIrEyUWnbjKKY2mzh1evl/GtvQUIpX3M
zpPYgo4J/Lne1FFKMYZ//54OiiTG3TtzklgQwq2nMZoMFhnFQl2+/0WedqVGXz+S
EZkjpLSothudtosGhMZS1g4NDjHg395CjOHCe7Po7+PLoBt6smJwf6roMUJZEjZ/
rLTDUd5daRSxKhReDuSe+anXyw6346mKIC3r5J2bEq8ncoEN2LS1jAmN6gGNAbB4
BlWu3/LOG0o=
=VsfU
-----END PGP SIGNATURE-----

--Sig_/v8w4PBLsZa5Z./r.XPituf8--
