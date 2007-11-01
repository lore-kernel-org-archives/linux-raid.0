From: Doug Ledford <dledford@redhat.com>
Subject: Re: Implementing low level timeouts within MD
Date: Thu, 01 Nov 2007 15:16:13 -0400
Message-ID: <1193944573.10336.684.camel@firewall.xsintricity.com>
References: <1193418753.4771.17.camel@w100>
	 <1193425254.10336.290.camel@firewall.xsintricity.com>
	 <87tzoc7soa.fsf@willow.rfc1149.net>  <1193721577.3876.12.camel@w100>
	 <1193765984.10336.519.camel@firewall.xsintricity.com>
	 <1193893689.3649.19.camel@w100>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-l3oJzMtCUkjQmP0tNFQ8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1193893689.3649.19.camel@w100>
Sender: linux-raid-owner@vger.kernel.org
To: Alberto Alonso <alberto@ggsys.net>
Cc: Samuel Tardieu <sam@rfc1149.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-l3oJzMtCUkjQmP0tNFQ8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-11-01 at 00:08 -0500, Alberto Alonso wrote:
> On Tue, 2007-10-30 at 13:39 -0400, Doug Ledford wrote:
> >=20
> > Really, you've only been bitten by three so far.  Serverworks PATA
> > (which I tend to agree with the other person, I would probably chock
>=20
> 3 types of bugs is too many, it basically affected all my customers
> with  multi-terabyte arrays. Heck, we can also oversimplify things and=20
> say that it is really just one type and define everything as kernel type
> problems (or as some other kernel used to say... general protection
> error).
>=20
> I am sorry for not having hundreds of RAID servers from which to draw
> statistical analysis. As I have clearly stated in the past I am trying
> to come up with a list of known combinations that work. I think my
> data points are worth something to some people, specially those=20
> considering SATA drives and software RAID for their file servers. If
> you don't consider them important for you that's fine, but please don't
> belittle them just because they don't match your needs.

I wasn't belittling them.  I was trying to isolate the likely culprit in
the situations.  You seem to want the md stack to time things out.  As
has already been commented by several people, myself included, that's a
band-aid and not a fix in the right place.  The linux kernel community
in general is pretty hard lined when it comes to fixing the bug in the
wrong way.

> > this up to Serverworks, not PATA), USB storage, and SATA (the SATA stac=
k
> > is arranged similar to the SCSI stack with a core library that all the
> > drivers use, and then hardware dependent driver modules...I suspect tha=
t
> > since you got bit on three different hardware versions that you were in
> > fact hitting a core library bug, but that's just a suspicion and I coul=
d
> > well be wrong).  What you haven't tried is any of the SCSI/SAS/FC stuff=
,
> > and generally that's what I've always used and had good things to say
> > about.  I've only used SATA for my home systems or workstations, not an=
y
> > production servers.
>=20
> The USB array was never meant to be a full production system, just to=20
> buy some time until the budget was allocated to buy a real array. Having
> said that, the raid code is written to withstand the USB disks getting
> disconnected as far as the driver reports it properly. Since it doesn't,
> I consider it another case that shows when not to use software RAID
> thinking that it will work.
>=20
> As for SCSI I think it is a greatly proved and reliable technology, I've
> dealt with it extensively and have always had great results. I know deal
> with it mostly on non Linux based systems. But I don't think it is
> affordable to most SMBs that need multi-terabyte arrays.
>=20
> >=20
> > > I'll repeat my plea one more time. Is there a published list
> > > of tested combinations that respond well to hardware failures
> > > and fully signals the md code so that nothing hangs?
> >=20
> > I don't know of one, but like I said, I've not used a lot of the SATA
> > stuff for production.  I would make this one suggestion though, SATA is
> > still an evolving driver stack to a certain extent, and as such, keepin=
g
> > with more current kernels than you have been using is likely to be a bi=
g
> > factor in whether or not these sorts of things happen.
>=20
> OK, so based on this it seems that you would not recommend the use
> of SATA for production systems due to its immaturity, correct?

Not in the older kernel versions you were running, no.

>  Keep in
> mind that production systems are not able to be brought down just to
> keep up with kernel changes. We have some tru64 production servers with
> 1500 to 2500 days uptime, that's not uncommon in industry.

And I guarantee not a single one of those systems even knows what SATA
is.  They all use tried and true SCSI/FC technology.

In any case, if Neil is so inclined to do so, he can add timeout code
into the md stack, it's not my decision to make.

However, I would say that the current RAID subsystem relies on the
underlying disk subsystem to report errors when they occur instead of
hanging infinitely, which implies that the raid subsystem relies upon a
bug free low level driver.  It is intended to deal with hardware
failure, in as much as possible, and a driver bug isn't a hardware
failure.  You are asking the RAID subsystem to be extended to deal with
software errors as well.

Even though you may have thought it should handle this type of failure
when you put those systems together, it in fact was not designed to do
so.  For that reason, choice of hardware and status of drivers for
specific versions of hardware is important, and therefore it is also
important to keep up to date with driver updates.

It's highly likely that had you been keeping up to date with kernels,
several of those failures might not have happened.  One of the benefits
of having many people running a software setup is that when one person
hits a bug and you fix it, and then distribute that fix to everyone
else, you save everyone else from also hitting that bug.  You have
chosen to use relatively new hardware from the OS driver standpoint
(well, not so new now, but it certainly was back when you installed
several of those failed systems), but opted out of keeping up to date
with the kernels that very well may have prevented what happened to you.
There are trade offs in every situation.  If your SMB customers can't
afford years old but well tested and verified hardware to build their
terabyte arrays from, then the reasonable trade off for using more
modern and less tested hardware is that they need to be willing to deal
with occasional maintenance downtime to update kernels or risk what
happened to them.  Just as your tru64 uptimes are fairly industry
standard, so is it pretty industry standard that lower cost/newer
hardware comes with compromises.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-l3oJzMtCUkjQmP0tNFQ8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHKiX8TzP9PM7pjw8RAkKtAJ0X2eXGP39c10N9A7bBESVCaYeoBwCfXqnz
JflNnYC8knG3p84xSygWYdI=
=YmCY
-----END PGP SIGNATURE-----

--=-l3oJzMtCUkjQmP0tNFQ8--

