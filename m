From: NeilBrown <neilb@suse.de>
Subject: Re: raid1 repair does not repair errors?
Date: Wed, 5 Feb 2014 09:51:56 +1100
Message-ID: <20140205095156.77ad40c9@notabene.brown>
References: <52EE3910.3040205@msgid.tls.msk.ru>
	<20140203120431.400a8a1b@notabene.brown>
	<20140203153644.4c530672@notabene.brown>
	<52EF45A0.3010401@msgid.tls.msk.ru>
	<52EFD608.6020106@msgid.tls.msk.ru>
	<20140204153042.4288240c@notabene.brown>
	<52F140D3.8080703@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/VlmB89jQ9i3Bd+Un+pF7Sc+"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52F140D3.8080703@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/VlmB89jQ9i3Bd+Un+pF7Sc+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 04 Feb 2014 23:34:43 +0400 Michael Tokarev <mjt@tls.msk.ru> wrote:

> 04.02.2014 08:30, NeilBrown wrote:
> []
> > I'm really on a roll here, aren't I.
>=20
> Well, we both are, unless I don't understand what "on a roll" means :)

"on a roll" usually means "enjoying a series of successes" though it can be
used ironically to mean "suffering a series of failures".  I intended the
second meaning...


>=20
> > I looked again and that code I've been trying to fix as actually perfec=
tly
> > fine.  I'm not sure whether to be happy to sad about that.
> >=20
> > But... I've found the bug.  I know this time because I actually tested =
it.
> > I tested and current mainline and it didn't work.  So I hunted and foun=
d a
> > bug.
> > But that buggy code isn't in 3.10.
> > So I tested 3.10 and it crashed.
> > Ah-ha I though.  So I looked at 3.10.27, and  it has different code.  I=
t has
> > the buggy code.  So I tested that and  it didn't work.
> > Then I applied  the patch below, and now it does.
> >=20
> > The bug was introduced by
> >=20
> > commit 30bc9b53878a9921b02e3b5bc4283ac1c6de102a
> > Author: NeilBrown <neilb@suse.de>
> > Date:   Wed Jul 17 15:19:29 2013 +1000
> >=20
> >     md/raid1: fix bio handling problems in process_checks()
> >=20
> > which moved the clearing for bi_flags up in a function to before it was
> > tested.  That wasn't really the right thing to do.
> >=20
> > When that was backported to 3.10 it fixed the crash, but introduce this=
 new
> > bug.
> >=20
> > Anyway enough of my rambling - here is the patch.  As I don't much feel=
 like
> > trusting my own results just a the moment I look forward to your
> > confirmation, one way or the other.
>=20
> Wow.  I see.
> Indeed, I'm running latest 3.10 now, 3.10.28.  I never really thought
> about testing other versions, because, well, this didn't look like some
> new issue to me, I thought it is some old stuff which hasn't changed
> much in 3.13 and up.  Well, if either of us knew it is specific to 3.10.y,
> we'd both behave differently from the beginning, aren't we? :)
>=20
> So I tried your patch (on top of my initial just-the-debugging changes), =
had to
> fix a few MIME =3Ddamages on the go, but that is not really interesing.  =
And
> this version actually appears to work, but does it silently.

I probably should get md to be a little more verbose when it tries to fix IO
errors.  I people like to know....

>=20
> After a repair run with your last patch applied, I see this:
>=20
> [  767.456457] md: requested-resync of RAID array md1
> [  767.486818] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> [  767.517404] md: using maximum available idle IO bandwidth (but not mor=
e than 200000 KB/sec) for requested-resync.
> [  767.548977] md: using 128k window, over a total of 2096064k.
> [  808.174908] ata6.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 acti=
on 0x0
> [  808.206395] ata6.00: irq_stat 0x40000008
> [  808.237186] ata6.00: failed command: READ FPDMA QUEUED
> [  808.267635] ata6.00: cmd 60/80:00:00:3e:3e/00:00:00:00:00/40 tag 0 ncq=
 65536 in
> [  808.267635]          res 41/40:00:23:3e:3e/00:00:00:00:00/40 Emask 0x4=
09 (media error) <F>
> [  808.329226] ata6.00: status: { DRDY ERR }
> [  808.359915] ata6.00: error: { UNC }
> [  808.392438] ata6.00: configured for UDMA/133
> [  808.421989] sd 5:0:0:0: [sdd] Unhandled sense code
> [  808.451361] sd 5:0:0:0: [sdd]
> [  808.480329] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
> [  808.509679] sd 5:0:0:0: [sdd]
> [  808.538719] Sense Key : Medium Error [current] [descriptor]
> [  808.568061] Descriptor sense data with sense descriptors (in hex):
> [  808.597257]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
> [  808.626981]         00 3e 3e 23
> [  808.656380] sd 5:0:0:0: [sdd]
> [  808.685550] Add. Sense: Unrecovered read error - auto reallocate failed
> [  808.715375] sd 5:0:0:0: [sdd] CDB:
> [  808.744933] Read(10): 28 00 00 3e 3e 00 00 00 80 00
> [  808.774678] end_request: I/O error, dev sdd, sector 4079139
> [  808.804412] end_sync_read: !BIO_UPTODATE
> [  808.834040] ata6: EH complete
> [  809.486124] md: md1: requested-resync done.
>=20
> and now, all pending sectors are gone from the drive, and subsequent reads
> of this place does not produce any errors.

Excellent!

>=20
> However, mismatch_cnt right after this repair run shows 128 (and never go=
es
> larger than 0 on subsequent repair runs).  I'm not sure what this 128 rea=
lly
> means, shouldn't it be just one for a single unreadable 512 bytes?

md/raid1 doesn't read individual sectors - it reads 64K at a time and if it
sees a problem it reports that as 128 sectors.  I agree this isn't ideal, b=
ut
refining the error down to just one sector is a lot of work for fairly litt=
le
gain.


>=20
> At the same time, mdadm --monitor reports:
>=20
> Feb  4 23:19:24 mother mdadm[4793]: RebuildFinished event detected on md =
device /dev/md1
> Feb  4 23:21:13 mother mdadm[4793]: RebuildFinished event detected on md =
device /dev/md1, component device  mismatches found: 128 (on raid level 1)
>=20
> So, your patch appears to work now, the only issue is that it is too sile=
nt:
> I'd expect to see at least some mention of "repairing this or that block"=
, or
> something like that.
>=20
> Meanwhile I found an interesting option of hdparm -- it is --make-bad-sec=
tor.
> So, despite all the warnings around it, I tried it on this very same prod.
> server, and marked the same sector as bad again, and re-run the whole thi=
ng
> (verifying that read of that sector actually produces an error).  And it =
all
> repeated exactly: repair run silently fixed the error and reported 128 fo=
und
> mismatches, and after repair run, this place is readable again.
>=20
>=20
> (What I'd love to see now, which is not related to mdadm in any way - is =
an
> ability to remap this place on the drive once and for all, making the fir=
st
> Reallocate_Event_Count to actually happen, to not bother with it ever aga=
in.
> As was possible with old good scsi drives, for many years..  Anyone know =
if
> it still possible today with sata drives?  To remap this place and be done
> with it, instead of repeating the same - rewrite, it is good now, but with
> time it becomes unreadable, so rewrite it again, ad infinitum...)
>=20
> > Thanks,
>=20
> Thank you!
>=20
> Should I try 3.13 kernel too (now when I know how to make a bad sector),
> just to verify it works fine without additional patches?

No, the same bug is present in every kernel since 3.10.something.
I'll send a patch upstream soon now that I have definite confirmation from
you that it works.

Thanks,
NeilBrown

--Sig_/VlmB89jQ9i3Bd+Un+pF7Sc+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUvFvFznsnt1WYoG5AQL8kg//RTSxrpGV4TGTOZz4tLhI5NYAeD2GgYNa
NPU+SMzHZmspC+k6EOE1jmuCiRSGN7Ao7HYanXhk1lFlPG5KtMrXXT5dmXXyvv9D
gwria8PCpBcBFKQvtNUwTa36Pj6k8sEsSqLUuWToMp3RAQCvPMBKe3/9sWg6H72r
a/QYjlOrOZBCrKoDwN+IM7ogETwLeYVzcd16geagKTMTWI4uu+guHYXo5vppl4HA
enf+d3czpg1wbfsujbxYu2HVesdKY6GlcfOP28V5+xagG58PgHZliP/OY7UYAUBD
c7pqeXVcRoxdekRz0THVEUdf0cXKPlc/hiFQUPaC15+lgTwsNVRRE8auTZT9UNMI
Lo9isgYP3HO4tXGMHPBeDRQhOWbOwUv9r+Mo4RdMVKHJXz5u5d4Bh62fZZbp1mnt
K8OvjaMhkmzJjNyHnN7VKGjuJE4XmG1zCqxsKpStVW0eCy99gL7d9WVdFxkTaYc3
EXa6eUD7i4t3wfeOx5k3H7klvy18K4XX4KH+b2n00IUWT+gqruTgcAOlx7bu3c8A
CvYAbOyMhZbY6q7uyCNcSMK9/63FUPe8Gg6QuSBgyjKj3kQc/Gb+GtxcKbeXGzBk
cWtSFsmpnr8oyejmYDyRyby6zL5Fhwy0H/9lTxz8BW23FndYR5P3XEW8qawaPkEv
E+FEMemKqoE=
=MvWV
-----END PGP SIGNATURE-----

--Sig_/VlmB89jQ9i3Bd+Un+pF7Sc+--
