From: NeilBrown <neilb@suse.de>
Subject: Re: [systemd-devel] systemd kills mdmon if it was started manually
   by user
Date: Mon, 7 Nov 2011 13:52:41 +1100
Message-ID: <20111107135241.64ae261d@notabene.brown>
References: <20110208094843.GD11446@tango.0pointer.de>
	<AANLkTi=rFoqBwKdd0B3Xx6JrGdJdut0a2r=wFh0oSx73@mail.gmail.com>
	<20110208110730.GF23157@tango.0pointer.de>
	<AANLkTinmO9gsJcwr+0bGGuVJfF2dyM5rDJqqSkmh_hqs@mail.gmail.com>
	<20110208172822.GC21847@tango.0pointer.de>
	<CAA9_cmfhUyenz2B1=wDsUtKcrj-5uOURproUemje37bPpM4-Qw@mail.gmail.com>
	<20111031110613.GA1402@tango.0pointer.de>
	<20111102114416.7879b77f@notabene.brown>
	<20111102011615.GA5289@tango.0pointer.de>
	<20111102130334.09c3ab51@notabene.brown>
	<20111102133223.GC5119@tango.0pointer.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/X=z5o5vctQnUyJdGchuKmm_"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111102133223.GC5119@tango.0pointer.de>
Sender: linux-raid-owner@vger.kernel.org
To: Lennart Poettering <lennart@poettering.net>
Cc: Dan Williams <dan.j.williams@intel.com>, Andrey Borzenkov <arvidjaar@mail.ru>, Tomasz Torcz <tomek@pipebreaker.pl>, systemd-devel@lists.freedesktop.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/X=z5o5vctQnUyJdGchuKmm_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 2 Nov 2011 14:32:25 +0100 Lennart Poettering <lennart@poettering.ne=
t>
wrote:

> On Wed, 02.11.11 13:03, NeilBrown (neilb@suse.de) wrote:

> > Each instance of mdmon manages a set of arrays and must remain running
> > until all of those arrays are readonly (or shut down).  This allows it =
to
> > record that all writes have completed and mark the array as 'clean' so a
> > resync isn't needed at next boot.
>=20
> Why doesn't the kernel do that on its own?

Because the kernel doesn't know about the format of the metadata that
describes the array.

> >=20
> > You couldn't just do the equivalent of
> >   fuser -k /some/filesystem
> >   umount /some/filesystem
> >=20
> > iterating over filesystems with '/' last?
> >
> > Then anything that only uses the /run filesystem will survive.
>=20
> What we do right now is this:
>=20
> kill_all_processes();
> do {
>      umount_all_file_systems_we_can();
>      read_only_mount_all_remaining_file_systems();
> } while (we_had_some_success_with_that());
> jump_into_initrd();
>=20
> As long as mdmon references a file from the root disk we cannot umount
> it, so the loop wouldn't be effective.

What exactly is "kill_all_processes()"?   is it SIGTERM or SIGKILL or both
with a gap or ???

I assume a SIGKILL.  I don't mind a SIGTERM and it could be useful to
expedite mdmon cleaning up.

However there is an important piece missing.  When you remount,ro a
filesystem, the block device doesn't get told so it thinks it is still open
read/write.  So md cannot tell mdmon that the array is now read-only
It would make a lot of sense for mdmon to exit after receiving a SIGTERM as
soon as the device is marked read-only.  But it just doesn't know.

We can probably fix that, but that doesn't really help for now.

I think I would like:

 - add to the above loop "stop any virtual devices that we can".
   Exactly how to do that if /proc and /sys are already unmounted
   is unclear.  Is one or both of these kept around somewhere?

 - allow processes to be marked some way so they get SIGTERM but not
   SIGKILL.  I'm happy adding magic char to argv[0].

We should be able to make it work with those changes - if they are possible.

Thanks,

NeilBrown


--Sig_/X=z5o5vctQnUyJdGchuKmm_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTrdH+jnsnt1WYoG5AQJ/fRAAnmWAYBVmp4U/H3kMFX1i1RZDe0a6J0O/
4u5KbT9YUyekvNfRW8PqckAO9semiUWAVuJHnm9uJA/1KjtUZBh2UygvJkerPSRV
jx6bWTt7iGbUtd8FhEV300Y/jkQ1y+QB/30TEVjvT145kZ69wDabqC33oWzcPi07
K36xh3+MOxSEj/bsSSMG5nDS/VyRlzwkRE5ddmIOcRtbrrqiBN93P65+w99KLtJS
JsbrQAWgsTjTaDP6UL414BLAMiakFNJd/E24ZTAgDnWwoPrrKKB5F9bD5U/AKmY5
rQS+DKQT4Usv8fGQUk9H8zfDWhW1Hqhlf6arj1OXckJ9DgxG45GlnS2st8fXU5aG
W8Va/tY5IfxOPt4Ze5QFJMiK4NbF57nepZTPShlKOgbIGzzmq5iQn9gHoi/Wz8zH
kX6a+rW+NnDeoyDFkuPSuwUYcSHLRxtN3zKIjdYLR4TiqCFwcXfv8SJJtW0xMz4n
KlYXzee8d0vWf9k0XfRnyZclJlAbRUwz1GQrwdqqzSlHmPO59NHKzly/ca6r4CWi
vTTo0oXaWvc3GeQAn/UhDMfw+T9uBjG27AgwrT1kHGSezcaySK5XoEpW8BHmwCe2
zGZ+yDKT4bnQuh1RctKHclpAt/TW0axqXzTYAF4pq0cwZ652UQMoaSpXTdL2iLT4
lDyl+R++7B0=
=HBHZ
-----END PGP SIGNATURE-----

--Sig_/X=z5o5vctQnUyJdGchuKmm_--
