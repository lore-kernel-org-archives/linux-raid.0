From: Doug Ledford <dledford@redhat.com>
Subject: Re: Implementing low level timeouts within MD
Date: Fri, 02 Nov 2007 11:45:26 -0400
Message-ID: <1194018326.25553.28.camel@firewall.xsintricity.com>
References: <1193418753.4771.17.camel@w100>
	 <1193425254.10336.290.camel@firewall.xsintricity.com>
	 <87tzoc7soa.fsf@willow.rfc1149.net>  <1193721577.3876.12.camel@w100>
	 <1193765984.10336.519.camel@firewall.xsintricity.com>
	 <1193893689.3649.19.camel@w100>
	 <1193944573.10336.684.camel@firewall.xsintricity.com>
	 <1193992909.3649.75.camel@w100>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-x5ZmGIxs0z6bCPpU6shH"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1193992909.3649.75.camel@w100>
Sender: linux-raid-owner@vger.kernel.org
To: Alberto Alonso <alberto@ggsys.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-x5ZmGIxs0z6bCPpU6shH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-11-02 at 03:41 -0500, Alberto Alonso wrote:
> On Thu, 2007-11-01 at 15:16 -0400, Doug Ledford wrote:
> > Not in the older kernel versions you were running, no.
>=20
> These "old versions" (specially the RHEL) are supposed to be
> the official versions supported by Redhat and the hardware=20
> vendors, as they were very specific as to what versions of=20
> Linux were supported.

The key word here being "supported".  That means if you run across a
problem, we fix it.  It doesn't mean there will never be any problems.

>  Of all people, I would think you would
> appreciate that. Sorry if I sound frustrated and upset, but=20
> it is clearly a result of what "supported and tested" really=20
> means in this case.

I'm sorry, but given the "specially the RHEL" case you cited, it is
clear I can't help you.  No one can.  You were running first gen
software on first gen hardware.  You show me *any* software company
who's first gen software never has to be updated to fix bugs, and I'll
show you a software company that went out of business they day after
they released their software.

Our RHEL3 update kernels contained *significant* updates to the SATA
stack after our GA release, replete with hardware driver updates and bug
fixes.  I don't know *when* that RHEL3 system failed, but I would
venture a guess that it wasn't prior to RHEL3 Update 1.  So, I'm
guessing you didn't take advantage of those bug fixes.  And I would
hardly call once a quarter "continuously updating" your kernel.  In any
case, given your insistence on running first gen software on first gen
hardware and not taking advantage of the support we *did* provide to
protect you against that failure, I say again that I can't help you.

>  I don't want to go into a discussion of
> commercial distros, which are "supported" as this is nor the
> time nor the place but I don't want to open the door to the
> excuse of "its an old kernel", it wasn't when it got installed.

I *really* can't help you.

> Outside of the rejected suggestion, I just want to figure out=20
> when software raid works and when it doesn't. With SATA, my=20
> experience is that it doesn't. So far I've only received one=20
> response stating success (they were using the 3ware and Areca=20
> product lines).

No, your experience, as you listed it, is that
SATA/usb-storage/Serverworks PATA failed you.  The software raid never
failed to perform as designed.

However, one of the things you are doing here is drawing sweeping
generalizations that are totally invalid.  You are saying your
experience is that SATA doesn't work, but you aren't qualifying it with
the key factor: SATA doesn't work in what kernel version?  It is
pointless to try and establish whether or not something like SATA works
in a global, all kernel inclusive fashion because the answer to the
question varies depending on the kernel version.  And the same is true
of pretty much every driver you can name.  This is why commercial
companies don't just certify hardware, but the software version that
actually works as opposed to all versions.  In truth, you have *no idea*
if SATA works today, because you haven't tried.  As David pointed out,
there was a significant overhaul of the SATA error recovery that took
place *after* the kernel versions that failed you which totally
invalidates your experiences and requires retesting of the later
software to see if it performs differently.

> Anyway, this thread just posed the question, and as Neil pointed
> out, it isn't feasible/worth to implement timeouts within the md
> code. I think most of the points/discussions raised beyond that
> original question really belong to the thread "Software RAID when=20
> it works and when it doesn't"=20
>=20
> I do appreciate all comments and suggestions and I hope to keep
> them coming. I would hope however to hear more about success
> stories with specific hardware details. It would be helpfull
> to have a list of tested configurations that are known to work.

I've had *lots* of success with software RAID as I've been running it
for years.  I've had old PATA drives fail, SCSI drives fail, FC drives
fail, and I've had SATA drives that got kicked from the array due to
read errors but not out and out drive failures.  But I keep at least
reasonably up to date with my kernels.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-x5ZmGIxs0z6bCPpU6shH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHK0YPTzP9PM7pjw8RAiGhAJ44WePbMhs7FGCN9Qkd6QGH71FxegCfTpfC
4NcUOQaHt98R8lbKnl2fGb0=
=Cm3B
-----END PGP SIGNATURE-----

--=-x5ZmGIxs0z6bCPpU6shH--

