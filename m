From: NeilBrown <neilb@suse.de>
Subject: Re: Questions about bitrot and RAID 5/6
Date: Tue, 21 Jan 2014 08:46:17 +1100
Message-ID: <20140121084617.582f9b75@notabene.brown>
References: <20140120203433.GY6553@blisses.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=De+6a65jH=aBSECsMYq77F"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140120203433.GY6553@blisses.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mason Loring Bliss <mason@blisses.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/=De+6a65jH=aBSECsMYq77F
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 20 Jan 2014 15:34:33 -0500 Mason Loring Bliss <mason@blisses.org>
wrote:

> I was initially writing to HPA, and he noted the existence of this list, =
so
> I'm going to boil down what I've got so far for the list. In short, I'm
> trying to understand if there's a reasonable way to get something equivla=
nt
> to ZFS/BTRFS on-a-mirror-with-scrubbing if I'm using MD RAID 6.
>=20
>=20
>=20
> I recently read (or attempted to read, for those sections that exceeded my
> background in math) HPA's paper "The mathematics of RAID-6", and I was
> particularly interested in section four, "Single-disk corruption recovery=
".
> What I'm wondering if he's describing something theoretically possible gi=
ven
> the redundant data RAID 6 stores, or something that's actually been
> implemented in (specifically) MD RAID 6 on Linux.
>=20
> The world is in a rush to adopt ZFS and BTRFS, but there are dinosaurs am=
ong
> us that would love to maintain proper layering with the RAID layer being =
able
> to correct for bitrot itself. A common scenario that would benefit from t=
his
> is having an encrypted layer sitting atop RAID, with LVM atop that.
>=20
>=20
>=20
> I just looked through the code for the first time today, and I'd love to =
know
> if my understanding is correct. My current read of the code is as follows:
>=20
> linux-source/lib/raid6/recov.c suggests that for a single-disk failure,
> recovery is handled by the RAID 5 code. In raid5.c, if I'm reading it
> correctly, raid5_end_read_request will request a rewrite attempt if uptod=
ate
> is not true, which can call md_error, which can initiate recovery.
>=20
> I'm struggling a little to trace recovery, but it does seem like MD maint=
ains
> a list of bad blocks and can map out bad sectors rather than marking a wh=
ole
> drive as being dead.
>=20
> Am I correct in assuming that bitrot will show up as a bad read, thus mak=
ing
> the read check fail and causing a rewrite attempt, which will mark the se=
ctor
> in question as bad and write the data somewhere else if it's detected? If
> this is the case then there's a very viable, already deployed option for
> catching bitrot that doesn't require complete upheaval of how people mana=
ge
> disk space and volumes nowadays.

ars technica recently had an article about "Bitrot and atomics COWs: Inside
"next-gen" filesystems."

http://feeds.arstechnica.com/~r/arstechnica/everything/~3/Cb4ylzECYVQ/

Early on it talks about creating a brtfs filesystem with RAID1 configured a=
nd
then binary-editing one of the device to flip one bit.  Then magically btrfs
survives while some other filesystem suffered data corruption.
That is where I stopped reading because that is *not* how bitrot happens.

Drives have sophisticated error checking and correcting codes.  If a bit on
the media changes, the device will either fix it transparently or report an
error - just like you suggest.  It is extremely unlikely to return bad data
as though it were good data.  And the codes that btrfs use have roughly the
same probability of reporting bad data as good - infinitesimal but not zero.

i.e. that clever stuff done by btrfs is already done by the drive!

To be fair to btrfs there are other possible sources of corruption than just
media defect.  On the path from the CCD which captures the photo of the cat,
to the LCD which displays the image, there are lots of memory buffers and
busses which carry the data.  Any one of those could theoretically flip one
or more bits.  Each of them *should* have appropriate error detecting and
correcting codes.  Apparently not all of them do.
So the magic in btrfs doesn't really protect against media errors (though if
your drive is buggy it could help there) but against errors in some (but not
all) other buffers or paths.

i.e. it sounds like a really cool idea but I find it very hard to evaluate
how useful it really is and whether it is worth the cost.   My gut feeling =
is
that for data it probably isn't.  For metadata it might be.

So to answer your question:  yes- raid6 on reasonable-quality drives already
protects you against media errors.  There are however theoretically possible
sources of corruption that md/raid6 does not protect you against.  btrfs
might protect you against some of those.  Nothing can protect you against a=
ll
of them.

As is true for any form of security (and here are at talking about data
security) you can only evaluate how safe you are against some specific thre=
at
model.  Without a clear threat model it is all just hand waving.

I had a drive one which had a dodgy memory buffer.  When reading a 4k block,
one specific bit would often be set when it should be clear.  md would not
help with that (and in fact was helpfully copying the corruption from the
source drive to a space in a RAID1 for me :-).  btrfs would have caught that
particular corruption if checksumming were enabled on all data and metadata.

md could conceivably read the whole "stripe" on every read and verify all
parity blocks before releasing any data.  This has been suggested several
times, but no one has provided code or performance analysis yet.

NeilBrown


>=20
> On a related note, raid6check was mention to me. I don't see that availab=
le
> on Debian or RHEL stable, but I found a man page:
>=20
>     https://github.com/neilbrown/mdadm/blob/master/raid6check.8
>=20
> The man page says, "No write operations are performed on the array or the
> components," but my reading of the code makes it seem like a read error w=
ill
> trigger a write implicitly. Am I misunderstanding this? Overall, am I bar=
king
> up the wrong tree in thinking that RAID 6 might let me preserve proper
> layering while giving me the data integrity safeguards I'd otherwise get =
from
> ZFS or BTRFS?
>=20
> Thanks in advance for clarifications and pointers!
>=20


--Sig_/=De+6a65jH=aBSECsMYq77F
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUt2ZKTnsnt1WYoG5AQI68hAAwcCRXxf0KtIidf2hO3flGAvhUM/FlRpG
jIdtR2z8qq6nBYi1lXLq01rUXNNH0XwwpRCmkHWUg+jawoJPSYA48/mWvOgHW3/g
saBAWplW1VOD/ZlQ9wqvbdEZ8R0JZ4ANncILkISCFuoZkQhZmYepvqTe+7OnfEs2
uAOGTguFhehY6KkxtLwIXCeQNZ3p4FWcdEflSOHQdUFkHnLeeAJvljxIUgHeGzT+
Ewq1ItcGNG3lSkhzxncXrJj6Xd0LYPVy5/u9HCQ9vaMBsXy2Llh7pjvim0+mV/bQ
WWKiE8E1LACvBV8MazQtanvNU2EJYhQEOZKScgksFNJeGavmzNDEP7c5y9xW/UkB
74eUA6V4TNDoEPCwt/0fxOJzXYg1IwjNY/rhF2A3uftnkpNIhFHdt1vpxP/EAwvX
Ohjj5Iyimp0qnwzYUL7Zstylb6xIXcUjukzwfJiSA+epTRxlQS7+ZFvi9yKHTPrA
zFCzZR6aO8E6US8NEJ5d7oMWIy7CIo/PcXWFVwualm6EMHmCbM6tk/2TRdPAEWF1
CpUZfVvk1EBVMlFzkalEz6celD8rkuqXaxmPxikf0ld2F/iuXXrkxJ0yJVJf4WaV
Pv8W8K6ZvRrS05/++HHXETFqtIk8IBuBylb1Br6qWPaEGNkXss+zSBD7QyfGkgw1
0UmmH/AHXdQ=
=rH5j
-----END PGP SIGNATURE-----

--Sig_/=De+6a65jH=aBSECsMYq77F--
