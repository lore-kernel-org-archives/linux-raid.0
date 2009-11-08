From: Doug Ledford <dledford@redhat.com>
Subject: Re: Successful RAID 6 setup
Date: Sun, 08 Nov 2009 11:15:27 -0500
Message-ID: <4AF6EE9F.3050709@redhat.com>
References: <20091104184049356.ZIDJ2725@cdptpa-omta04.mail.rr.com> 	<4AF5BDF3.8020907@redhat.com> <aebf5d970911072242l3876282fm93dc938dd3df1990@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7AC5BC496AB6009F3E762D25"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <aebf5d970911072242l3876282fm93dc938dd3df1990@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Beolach <beolach@gmail.com>
Cc: Leslie Rhorer <lrhorer@satx.rr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7AC5BC496AB6009F3E762D25
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 11/08/2009 01:42 AM, Beolach wrote:
> On Sat, Nov 7, 2009 at 11:35, Doug Ledford <dledford@redhat.com> wrote:=

>> On 11/04/2009 01:40 PM, Leslie Rhorer wrote:
>>>       I would recommend a larger chunk size.  I'm using 256K, and eve=
n
>>> 512K or 1024K probably would not be excessive.
>>
>> OK, I've got some data that I'm not quite ready to send out yet, but i=
t
>> maps out the relationship between max_sectors_kb (largest request size=
 a
>> disk can process, which varies based upon scsi host adapter in questio=
n,
>> but for SATA adapters is capped at and defaults to 512KB max per
>> request) and chunk size for a raid0 array across 4 disks or 5 disks (I=

>> could run other array sizes too, and that's part of what I'm waiting o=
n
>> before sending the data out).  The point here being that a raid0 array=

>> will show up more of the md/lower layer block device interactions wher=
e
>> as raid5/6 would muddy the waters with other stuff.  The results of th=
e
>> tests I ran were pretty conclusive that the sweet spot for chunk size =
is
>> when chunk size is =3D=3D max_sectors_kb, and since SATA is the predom=
inant
>> thing today and it defaults to 512K, that gives a 512K chunk as the
>> sweet spot.  Given that the chunk size is generally about optimizing
>> block device operations at the command/queue level, it should transfer=

>> directly to raid5/6 as well.
>>
>=20
> This only really applies for large sequential io loads, right?  I seem
> to recall
> smaller chunk sizes being more effective for smaller random io loads.

Actually, no.  Small chunk sizes don't help with truly random I/O.
Assuming the I/O is truly random, your layout doesn't really matter
because no matter how you lay stuff out, your still going to get random
I/O to each drive.  The only real reason to use small chunk sizes in the
past, and this reason is no longer true today, was to stream I/O across
all the platters simultaneously on even modest size sequential I/O in
order to be able to get the speed of all drives combined as your maximum
I/O speed.  This has always, and still does, hurt random I/O
performance.  But, back in the day when disks only did 5 to 10MB/s of
throughput, and the computer could do hundreds, it made a certain amount
of sense.  Now we can do hundreds per disk, and it doesn't.  Since the
sequential performance of even a single disk is probably good enough in
most cases, it's far preferable to optimize your array for random I/O.

Well, that means optimizing for seeks.  In any given array, your maximum
number of operations is equal to the maximum number of seeks that can be
performed (since with small random I/O you generally don't saturate the
bandwidth).  So, every time a command spans a chunk from one disk to the
next, that single command consumes one of the possible seeks on both
disks.  In order to optimize for seeks, you need to reduce the number of
seeks per command in your array as much as possible, and that means at
least attempting to keep each read/write, whether random or sequential,
on a single disk for as long as possible.  This gives the highest
probability that any given command will complete while only accessing a
single disk.  If that command completes while only touching a single
disk, all the other disks in your array are free to complete other
commands simultaneously.  So, in an optimal raid array for random I/O,
you want all of your disks handling a complete command at a time so that
your disks are effectively running in parallel.  When commands regularly
span across chunks to other disks you gain speed for a specific command
at the expense of consuming multiple seeks.

Past testing has shown that this effect will produce increased
performance under random I/O even with chunk sizes going up to 4096k.
However, we reached a point of diminishing returns somewhere around
256k.  It seems that as soon as you reach a chunk size equal (or roughly
equal) to the max command size for a drive, then it doesn't do much
better to go any higher (less than 1% improvement for huge jumps in
chunk size).  We didn't fully analyse it, but I would venture to guess
that most likely the maximum command size is large enough that the read
ahead code in the filesystem might grab up to one commands worth of data
in a short enough period of time for it to be considered sequential by
the disk, but would take long enough before grabbing the next sequential
chunk that other intervening reads/writes would have essentially made
these two sequential operations have an intervening seek and therefore
be as random themselves (speaking of one large sequential I/O in the
middle of a bunch of random I/O).

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig7AC5BC496AB6009F3E762D25
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkr27p8ACgkQg6WylM+/8ZQvTACgn8eRXL0/8A+lrDLu5aGux3xE
zEMAn0v3M7t3U/ut04KHt3wik11EfuSO
=/6CG
-----END PGP SIGNATURE-----

--------------enig7AC5BC496AB6009F3E762D25--
