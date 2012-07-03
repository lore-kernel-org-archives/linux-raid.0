From: NeilBrown <neilb@suse.de>
Subject: Re: Fatal crash/hang in scsi_lib after RAID disk failure
Date: Tue, 3 Jul 2012 16:45:28 +1000
Message-ID: <20120703164528.5b9b4a7c@notabene.brown>
References: <20120629093552.1651d3c2@batzmaru.gol.ad.jp>
	<20120703155045.570a2bee@notabene.brown>
	<20120703151038.428af28f@batzmaru.gol.ad.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/toY=wVM_aS5/ZZ+5pr+9pzx"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120703151038.428af28f@batzmaru.gol.ad.jp>
Sender: linux-raid-owner@vger.kernel.org
To: Christian Balzer <chibi@gol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/toY=wVM_aS5/ZZ+5pr+9pzx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 3 Jul 2012 15:10:38 +0900 Christian Balzer <chibi@gol.com> wrote:

> On Tue, 3 Jul 2012 15:50:45 +1000 NeilBrown wrote:
>=20
> > On Fri, 29 Jun 2012 09:35:52 +0900 Christian Balzer <chibi@gol.com>
> > wrote:
> >=20
> > >=20
> > > Hello (Neil),
> > >=20
> > > This may or may not be related to the same main error I found a
> > > reference to on the ML archives from November 2011=20
> > > (kernel BUG at drivers/scsi/scsi_lib.c:1153).
> > >=20
> > > Again, this is a 3.2.20 kernel, now with the Raid10 recovery bug patc=
h,
> > > but I don't see how this could be related.
> > >=20
> > > The full initial dump, as far as it was logged is here:
> > > http://pastebin.com/wFX5yew2
> > >=20
> > > But the juicy bits are these:
> > > ---
> > > Jun 29 05:06:42 borg03b kernel: [231632.877579] sd 8:0:5:0: [sdj]
> > > Unhandled sense code Jun 29 05:06:42 borg03b kernel: [231632.877583]
> > > sd 8:0:5:0: [sdj]  Result: hostbyte=3Dinvalid driverbyte=3DDRIVER_SEN=
SE
> > > Jun 29 05:06:42 borg03b kernel: [231632.877586] sd 8:0:5:0: [sdj]
> > > Sense Key : Medium Error [current] Jun 29 05:06:42 borg03b kernel:
> > > [231632.877590] Info fld=3D0x904ff8b8 Jun 29 05:06:42 borg03b kernel:
> > > [231632.877591] sd 8:0:5:0: [sdj]  Add. Sense: Unrecovered read error
> > > Jun 29 05:06:42 borg03b kernel: [231632.877595] sd 8:0:5:0: [sdj] CDB:
> > > Read(10): 28 00 90 4f f8 3f 00 00 f8 00 Jun 29 05:06:42 borg03b
> > > kernel: [231632.877602] end_request: critical target error, dev sdj,
> > > sector 2421159999 Jun 29 05:06:42 borg03b kernel: [231632.881963]
> > > md/raid10:md4: sdj1: rescheduling sector 6052895744 Jun 29 05:06:46
> > > borg03b kernel: [231636.380147] sd 8:0:5:0: [sdj] Unhandled sense code
> > > Jun 29 05:06:46 borg03b kernel: [231636.380150] sd 8:0:5:0: [sdj]
> > > Result: hostbyte=3Dinvalid driverbyte=3DDRIVER_SENSE Jun 29 05:06:46
> > > borg03b kernel: [231636.380153] sd 8:0:5:0: [sdj]  Sense Key : Medium
> > > Error [current] Jun 29 05:06:46 borg03b kernel: [231636.380157] Info
> > > fld=3D0x904ff8b8 Jun 29 05:06:46 borg03b kernel: [231636.380159] sd
> > > 8:0:5:0: [sdj]  Add. Sense: Unrecovered read error Jun 29 05:06:46
> > > borg03b kernel: [231636.380162] sd 8:0:5:0: [sdj] CDB: Read(10): 28 00
> > > 90 4f f8 b7 00 00 08 00 Jun 29 05:06:46 borg03b kernel:
> > > [231636.380168] end_request: critical target error, dev sdj, sector
> > > 2421160119 Jun 29 05:06:46 borg03b kernel: [231636.401781]
> > > ------------[ cut here ]------------ Jun 29 05:06:46 borg03b kernel:
> > > [231636.405694] kernel BUG at drivers/scsi/scsi_lib.c:1153! Jun 29
> > > 05:06:46 borg03b kernel: [231636.405694] invalid opcode: 0000 [#1] SMP
> > > ---
> > >=20
> > > So a drive died, which shouldn't be a big deal and the kernel decided
> > > to jump off the proverbial bridge.
> > >=20
> > > And kept doing that upon reboots:
> > > ---
> > > Jun 29 06:44:38 borg03b kernel: [   52.052257] end_request: critical
> > > target error, dev sdj, sector 2421149759 Jun 29 06:44:38 borg03b
> > > kernel: [   52.054654] md/raid10:md4: sdj1: rescheduling sector
> > > 6052870144 Jun 29 06:44:38 borg03b kernel: [   52.057104]
> > > md/raid10:md4: sdj1: rescheduling sector 6052870392 Jun 29 06:44:38
> > > borg03b kernel: [   52.059521] md/raid10:md4: sdj1: rescheduling
> > > sector 6052870400 Jun 29 06:44:38 borg03b kernel: [   52.061878]
> > > md/raid10:md4: sdj1: rescheduling sector 6052870648 Jun 29 06:44:38
> > > borg03b kernel: [   52.064255] md/raid10:md4: sdj1: rescheduling
> > > sector 6052870656 Jun 29 06:44:38 borg03b kernel: [   52.066562]
> > > md/raid10:md4: sdj1: rescheduling sector 6052870904 Jun 29 06:44:38
> > > borg03b kernel: [   52.068872] md/raid10:md4: sdj1: rescheduling
> > > sector 6052870912 Jun 29 06:44:38 borg03b kernel: [   52.071141]
> > > md/raid10:md4: sdj1: rescheduling sector 6052871160 Jun 29 06:44:39
> > > borg03b kernel: [   52.250525] md/raid10:md4: sdj1: redirectingsector
> > > 6052865024 to another mirror Jun 29 06:44:39 borg03b kernel:
> > > [   52.276817] md/raid10:md4: sdj1: redirectingsector 6052865272 to
> > > another mirror Jun 29 06:44:42 borg03b kernel: [   55.325297] sd
> > > 8:0:5:0: [sdj] Unhandled sense code Jun 29 06:44:42 borg03b kernel:
> > > [   55.325301] sd 8:0:5:0: [sdj]  Result: hostbyte=3Dinvalid
> > > driverbyte=3DDRIVER_SENSE Jun 29 06:44:42 borg03b kernel: [   55.3253=
04]
> > > sd 8:0:5:0: [sdj]  Sense Key : Medium Error [current] Jun 29 06:44:42
> > > borg03b kernel: [   55.325308] Info fld=3D0x904fc9b4 Jun 29 06:44:42
> > > borg03b kernel: [   55.325310] sd 8:0:5:0: [sdj]  Add. Sense:
> > > Unrecovered read error Jun 29 06:44:42 borg03b kernel: [   55.325313]
> > > sd 8:0:5:0: [sdj] CDB: Read(10): 28 00 90 4f c9 af 00 00 08 00 Jun 29
> > > 06:44:42 borg03b kernel: [   55.325320] end_request: critical target
> > > error, dev sdj, sector 2421148079 Jun 29 06:44:42 borg03b kernel:
> > > [   55.343766] ------------[ cut here ]------------ Jun 29 06:44:42
> > > borg03b kernel: [   55.346054] kernel BUG at
> > > drivers/scsi/scsi_lib.c:1153! --- Which resulted a bit later in: ---
> > > Jun 29 06:45:05 borg03b kernel: [   57.051653] ------------[ cut
> > > here ]------------ Jun 29 06:45:05 borg03b kernel: [   57.051653]
> > > WARNING: at kernel/watchdog.c:241
> > > watchdog_overflow_callback+0x96/0xa1() Jun 29 06:45:05 borg03b kernel:
> > > [   57.051653] Hardware name: H8DM3-2 Jun 29 06:45:05 borg03b kernel:
> > > [   57.051653] Watchdog detected hard LOCKUP on cpu 7 ---
> > >=20
> > > Not sure if there is a real HW problem (aside from the failing drive)
> > > and kettle calling the pot black, but I managed to recover things by
> > > booting into single-user mode and removing that failing drive before
> > > letting the kernel proceed with booting.
> > >=20
> > > This is pretty bad [TM], any ideas?
> > > If you need more information, just let me know.
> >=20
> > That took *way* to long to find given how simple the fix is.
>=20
> Well, given how long it takes with some OSS projects, I'd say 4 days is
> pretty good. ^o^

I meant the 4 hours of my time searching, not the 4 days of your time
waiting :-)


>=20
> > I spent ages staring at the code, as about to reply and so "no idea"
> > when I thought I should test it myself.  Test failed immediately.
>=20
> Could you elaborate a bit?=20
> As in, was this something introduced only very recently, since I had
> dozens of disks fail before w/o any such pyrotechnics.=20
> Or were there some special circumstances that triggered it?=20
> (But looking at the patch, I guess it should have been pretty universal)

Bug was introduced by commit 58c54fcca3bac5bf9 which first appeared in
Linux 3.1.  Since then, any read error on RAID10 will trigger the bug.

I really need to improve my testing!

>=20
> > Then I spent way too look adding tracing into the wrong places.  But I
> > have it now!
> >=20
> > Thanks for the report.  Following fix will go upstream shortly.
> > (r10_sync_page_io takes sectors, not bytes).
> >=20
> Great to know, I shall keep my eyes on the kernel ChangeLogs and update
> as soon as I can. Might just go and patch what I have right now, though...
>=20
> Thanks for your efforts!

Thanks,
NeilBrown

--Sig_/toY=wVM_aS5/ZZ+5pr+9pzx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/KVCDnsnt1WYoG5AQISoQ//WjCkWb2ABZu0ehHH9BZ7kwGhDRl1uxiS
1uQUp0qgIA/WvT5zDuBbHJlml7ZZ5S48oDxsbH7FG3KNTSBav0mN2AfgGYDs/Q2q
y+k+BfiePflK6UjYjl6fCIUA1a6s2afBhOAUFGJUshFJ8STUKQc2x7jjM9on76KU
nyAneNI60po2TXeUSqn70IssOyJBQTqR+yNK2qvrDsrb0DfzVFne5sWWXX9+arI9
gCzzC/CcopVmJ60u2ieDwKc+43XRQ7vdAUkC13E1pn9kRvywea7atM3AzROV/+bK
zVURiSDamFttdyYj9zHkGxAMr5Hejab0do3QH3fH6pp2nxLXqfzAp2Tdd+Rk/xVU
S+big2Y3hUs7PeldT7GRoXV7VCeN20VGrqmcxoePNXDOPlQeCPwms3Nl/GgEppEV
iKw/a+D3/YwG+NL7zix38UgMG/MvJEcUc/Mvc+M62oZk8LKCuZaj1FSyrEofrcxi
hJG7xjIzzNu9atku+wwg6uk79xONlYae6LZW6vrPbj2nPCLEe7oAQ2MjkHTXChBb
RcY6t3FAoEVC4sEn7k1bGb54cL4mPD0idFqNHWxeeVgZq6JKLbnTOuqaRk6oyoUj
niJVN2sH8wEBn42jokypPBt61IpdooVNJ+1P96w8++4SBwFJcXbyyTjBmM5/y7c9
zL+9fEEBVRw=
=lIwC
-----END PGP SIGNATURE-----

--Sig_/toY=wVM_aS5/ZZ+5pr+9pzx--
