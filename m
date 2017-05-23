From: NeilBrown <neilb@suse.com>
Subject: Re: 4.11.2: reshape raid5 -> raid6 atop bcache deadlocks at start on md_attr_store / raid5_make_request
Date: Tue, 23 May 2017 11:39:44 +1000
Message-ID: <87y3toic67.fsf@notabene.neil.brown.name>
References: <87lgppz221.fsf@esperi.org.uk> <87a865jf9a.fsf@notabene.neil.brown.name> <87o9ukykmk.fsf@esperi.org.uk> <592336E6.8080906@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <592336E6.8080906@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Nix <nix@esperi.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Mon, May 22 2017, Wols Lists wrote:

> On 22/05/17 16:30, Nix wrote:
>> I'll give it a try -- I hit it twice in succession, once with a
>> --backup-file, once without. Since mdadm does not warn about the lack of
>> a --backup-file, I guess the statement in the manual that it is
>> essential to provide one when changing RAID levels is untrue: I suspect
>> that it's necessary *if* you're not increasing the number of disks at
>> the same time, but since I'm growing into a spare, adding a
>> --backup-file only slows it down?
>
> I did discuss this with Neil while I wrote it, so I hope I got it right :-)
>
> https://raid.wiki.kernel.org/index.php/A_guide_to_mdadm#Array_internals_and_how_it_affects_mdadm
>
> aiui, provided you're using a v1 superblock, the data offset means there
> is spare space on the drives precisely for the purpose (one of then at
> least) of keeping a backup. So the reshape will start reshaping into the
> spare space and eliminate the need for the backup - the new version of
> the stripe will be safely written before the space occupied by the old
> stripe is required.
>
> Cheers,
> Wol

Proof-reading time.  I'll be very picky.  You'll ignore places where you
think my pickiness isn't helpful.

> The first arrays did not have a superblock, and were declared in
> mdadm.conf.

The first arrays (linear and raid0 only) did not have a superblock and
were declared in "raidtab" which was managed by the deprecated
"raid-tools" which have been replaced by mdadm.

mdadm does now allow you to declare no-superblock arrays in mdadm.
You can build them with "mdadm --build .....", but that is all.

> and the backup area when reshaping an array.

Not quite.  The whole point of being able to move the data offset
is that backup isn't needed.  Maybe it could read:

 ... and some extra space so that the data areas can be moved forward or
 backward on the device by several stripes.  This is useful when
 reshaping.

> All operations that involve moving data around are called reshapes,
> and require some form of backup.

 All operations that involve moving data around are called reshapes and
 need to be careful only to write to a region of the device which
 can safely be corrupted.  If a system crash happens during a reshape,
 the region that was being written to must be considered to contain
 garbage.
 The preferred mechanism is to relocate the data by a few stripes,
 reading data from a region of the disk that contains live data, and
 writing it into a sliding window that is otherwise unused.  After a few
 stripes have been copied, the metadata in the superblock is updated, so
 that the newly written data is now "live" and the location it was
 copied from is now "unused" and can have more stripes copied into it.
 This process results in the Data Offset being moved by several
 megabytes, either forward or backward, and it is to allow for this to
 happen that the Data Offset is set to several to many megabytes when an
 array is created.

 If it is not possible to move the Data Offset, either because there is
 no room or because the v0.90 superblock is in use, mdadm will take a
 backup of the region of data being reshaped before it allows the
 reshape to progress.  In the event of a crash, mdadm will restore this
 data over the potentially corrupted region of the array before starting
 the array.

Your current text already covers some of this, and there probably isn't a
need to replace it all.
But I think it is important not to talk about the reserved space in the
devices a backup space.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkjkuAACgkQOeye3VZi
gbnZehAAslEbsi/sqvwrWTEN0K0wHuD1NiUNRB/nME0IQu98SfP665Kt25Rr53F2
B1nn1tNMvqoHGlcOIdGjp2T7pbBXQUUdBj2/QOsUEmT3O3/g5SRr76vXBP014bz+
lciVN40o9Qfh4nBL/CQpwk5BOY0fjDAMAudAmtpmUnrq6NKaPCJ5kqRsASLSc6Z+
c1ZVjR3A62J04BpwJbQDy/xYwgVrWVLI7tEe68Nfzft29ozqzbJg1noy6tMhSNW3
HeVPrw9awcWKpsStmq38bCgUHsy/Yry8V/muWy+HJuoMiLmphq2r030/WyGAnPP0
IBqxrSbeM5BEoqsQVQXF6mo4QUuD7AkMR1vcGCZmVPxtgAXLPWKjvz82bzrn+Xqq
SS/2h8IBSTOUYQTUfKARRN50OKX4/ll4sQ2186BztEfK7W41RIn5/BAVFJolE5iO
SdK1tDA8lzaOg1jgXXDZiPoi0l508CGl4O7Iroi7AU9HY0c8A+k0yW+Rqj7W+8Dr
IIpkepx5DbqEnP6AA/mZ+f7bbLq5wRR3ksHFiw6btE5i9NBTFE4ehng6dMo9S0Io
QuKWkzuut48QgoFYI+GFvOtOud+TuwWVO4TtVe3WkNnPeq8C+ppB1bmjMygWtJYa
GnVgdD+6SWPTDIKqhkMDiTf8TiBFKkbM0lAp9dZ4FCJCP6QFLV4=
=YbXo
-----END PGP SIGNATURE-----
--=-=-=--
