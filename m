From: Andy Smith <andy@strugglers.net>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Wed, 5 Jan 2005 09:56:58 +0000
Message-ID: <20050105095658.GX99565@caffreys.strugglers.net>
References: <m3is6k4oeu.fsf@reason.gnu-hamburg> <m38y7fn4ay.fsf@reason.gnu-hamburg> <v3rda2-hjn.ln1@news.it.uc3m.es> <41D45C1F.5030307@tls.msk.ru> <u59ea2-4qr.ln1@news.it.uc3m.es> <20050102194240.GE99565@caffreys.strugglers.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XGH+X5Sk6wksXc5a"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20050102194240.GE99565@caffreys.strugglers.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--XGH+X5Sk6wksXc5a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

As a small request please could those who are posting opinions on
the following:

 - What level of schooling any person's mathematical ability resembles

 - Whether Peter's computing environment is sane or not

 - IQ level and admin skills of various persons

 - Issues of p2p, rootkits, unruly students, etc. etc.

Plus various other personal attacks and ad hominem:

Please consider if what you are writing is relevant to this list
(linux-raid) or the subject of this thread (whether it is wise to
put the journal for an ext3 filesystem internal to the filesystem
when it is on a RAID-1 mirror).

Obviously I am not a moderator or even anyone of any influence, but
the majority of text I am now seeing in this thread is not useful to
read and (since it is archived) may actually be giving a bad
impression of its poster for all time.

=46rom what I can understand of the thread so far, Peter is saying the
following:

        RAID mirrors are susceptible to increasing undetectable
        inconsistencies because, as we all know, filesystems sustain
        corruption over time.
       =20
        On a filesystem that runs from one disk, corruption serious
        enough to affect the stability of the file system will do so
        and so will be detected.  As more disks are added to the
        mirror, the probability of that corruption never being seen
        naturally goes up.

        Peter personally does not put the journal inside the mirror
        because if he ever came to need to use the journal and found
        that it was corrupted, it could risk his whole filesystem.
        Peter prefers to put the journal on a separate device that
        is not mirrored.

I am not trying to put words into your mouth Peter, just trying to
summarise what your points are.  If I haven't represented your views
correctly then by all means correct me but please try to do so
succinctly and informatively.

Now, others are saying in response to this, things like:

        Spontaneous corruption is rare compared to outright or
        catastrophic device failure, and although it is more
        likely to go unnoticed with RAID mirrors, while it IS
        unnoticed, this presumably correct data is also being rewritten
        back to the filesystem.
       =20
        Mirrors help protect against the more common complete device
        failure and so a journal should surely be on a mirror since
        if you lose the journal then the machine needs to go down
        anyway.  It is unavailability of the server we're trying to
        avoid; consistency of the data can be protected with regular
        backups and possibly measured with other methods like
        md5sum.

Discuss? ;)

--XGH+X5Sk6wksXc5a
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (FreeBSD)

iD8DBQFB27nqIJm2TL8VSQsRAjWJAKD6uddDv++vvp9Sbt4Ujnr/js0B5QCeNGXZ
S9Msz5kNOdEGVbgGJs1EUt8=
=7y0+
-----END PGP SIGNATURE-----

--XGH+X5Sk6wksXc5a--
