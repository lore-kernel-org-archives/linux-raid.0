From: Andy Smith <andy@lug.org.uk>
Subject: Re: swp - Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Wed, 5 Jan 2005 17:26:27 +0000
Message-ID: <20050105172627.GQ99565@caffreys.strugglers.net>
References: <20050105162337.GL99565@caffreys.strugglers.net> <Pine.LNX.3.96.1050105090049.9654A-100000@Maggie.Linux-Consulting.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+U0EQ97FbU8QddnY"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.3.96.1050105090049.9654A-100000@Maggie.Linux-Consulting.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--+U0EQ97FbU8QddnY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 05, 2005 at 09:04:57AM -0800, Alvin Oga wrote:
> On Wed, 5 Jan 2005, Andy Smith wrote:
>=20
> > On Wed, Jan 05, 2005 at 07:33:55AM -0800, Alvin Oga wrote:
> > >=20
> > > if one is using swap space ... i'd add more memory .. before i'd use =
raid
> > > 	- swap is too slow and as you folks point out, it could die
> > > 	due to (unlikely) bad disk sectors in swap area
> ...
> =20
> > Your recommendations
>=20
> that'd be your comment ... that is not whati said above

Direct quote:

        i'd add more memory before i'd use raid
       =20
> and all i said, was use memory before you use swap on disks

Which means what?  Who is there on this list who likes to use swap
*before* physical memory?

Do all your machines which you believe have adequate memory also
have no swap configured?

Fact is if your machine has swap configured then that swap is part
of your virtual memory and if a device that is providing part of
your virtual memory suddenly fails then your machine is going down.

> and if you are at the 2GB lmit of your mb ... you obviously don't
> have a choice
> 	- if you are using 128MB of memory and using 2GB of swap
> 	and bitching about a slow box or system crashing due to swap...
> 	- that was the point ... add more memory

No one here is bitching about a slow machine due to swap usage and
if they were I'd wonder why they are doing it on linux-raid.

I repeat, if "add more memory" is your answer to "swapping on a
single device which then dies kills my machine" then does that mean
that your machines are configured with no swap?

All people are saying is that if you don't mirror swap then disk
failures cause downtime.  You are replying to add more memory and
don'trun things that can get swapped.  Those don't seem like very
useful recommendations.

> 	- and i don't think anybody is idiotic enough to add
> 	more memory for the "spikes" in the workload

OK so you must add swap to handle those spikes which means either
you are happy that your machine will crash should the device that
the swap is on die, or you use swap on a mirror to try to mitigate
that.

> > so far have been "don't run processes which
> > might swap" and "don't let swap be used".  If you yourself are able
> > to keep to both of these 100% of the time may I ask why you yourself
> > have any swap at all?
>=20
> you're twisting things again... but no problem.. have fun doing that

=46rom previous email (not a direct quote):

        Don't run lpd on user-accessible machine

(after given an example of some lpd process which gets swapped
out and back in again).

> > ometimes) or those of us in the real world where swap is desirable
> > and may (sometimes) be used, a swap device failure *will* *take*
> > *the* *machine* *down*.
>=20
> my real world is obviously better .... since we do NOT suffer
> from these mysterious disks crashes

If you do not suffer disk crashes then why do you use mirrors at
all?  If you do suffer disk crashes then any disk that is providing
swap may very well cause the machine to crash.

I thought everyone suffered disk crashes and that was the point of
RAID.

--+U0EQ97FbU8QddnY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (FreeBSD)

iD8DBQFB3CNDIJm2TL8VSQsRAh2MAKC3ZimLZc38WwBYeTOt6Azpj2QEcgCg5RJZ
RqNtYDHVSoKud1Irwpa1twQ=
=e8yW
-----END PGP SIGNATURE-----

--+U0EQ97FbU8QddnY--
