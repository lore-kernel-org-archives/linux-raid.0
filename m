From: bernd@rhm.de
Subject: Re: Linux 2.6.10 / RAID1 problem
Date: Wed, 5 Jan 2005 23:46:56 +0100 (MEZ)
Message-ID: <200501052246.XAA07775@node130.rhm.de>
References: <41DC515C.7030208@anduras.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41DC515C.7030208@anduras.de> from Sven Anders at "Jan 5, 5 09:43:08 pm"
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Sven,

we used RAID1 under Kernel 2.4.x without any problems (except the count=
ers
for activ- and spare disks became wrong). With kernel 2.6.x RAID1 is a=20
desaster. This problem was dicussed in this newsgroup in the second hal=
f
of last year. The kernel dies if a disk fails or if the system is heavy=
=20
loaded (the latter one we can't reproduce but it happens, may be there
will be some other issues on the SCSI bus for other reasons leading to
the same result).=20

If one disk fails or if there is a bus reset on one of the two SCSI
controlles we are using for RAID1 the system crashes. It doesn't go
on with the remaining disk on the other controller which is expected
for RAID1 (and what is the reason for using RAID1 at all!). In the=20
logs we see many failed superblock writes and other strange things
just before the kernel gives up and dies. From another company we=20
heard about data corruptions if the above takes place. We didn't see=20
this, may be we are using Reiserfs which they don't.=20

I asked about the state of this problem some days ago in a new thread=20
in this newsgroup but there was no response. I wonder nobody has simila=
r
problems out there.

Another hint. You can't reproduce this using mdadm -f to set a disk
faulty. This will work fine because it enters the kernel in a=20
different way as a 'real' disk failure will do.

So in summary I can answer your question about stability of RAID1
under 2.6.x with no, even if our problems do not correspond exactely
to yours!!!

Greetings Bernd Rieke
R&H Computer Systems
Tel +49 (0)89 750078

-----------------------------------------------------------------------=
--

>Hello!
>
>I'm expirencing strange problems on my server running Software RAID1 (=
Mirroring) under
>the Linux kernel 2.6.10. It works nicely under Linux 2.4.18!
>
>Configuration:
>~ Athlon 1.5GHz, 256MB RAM (tested!)
>~ 2x160GB Harddisks (same type) on different IDE controllers
>~  (ext3 fs with journalling turned on)
>~ Swap is turned off
>~ Linux Kernel 2.6.10 (vanilla) without SMP, Preemption turned off
>
>Test case:
>~ dd if=3D/dev/zero of=3Dtest0 bs=3D1M count=3D300
>~ while :; do cp test0 test1; cp test1 test2; cp test2 test0; od test0=
; done
>
>Error:
>~ On Linux 2.4.18 it worked serveral hours perfectly (until I stopped =
it...)
>~ On Linux 2.6.10 after some minutes the following (or similar) error =
occures:
>
>EXT3-fs error (device md5): ext3_free_blocks_sb: bit already cleared f=
or block 1303980
>Aborting journal on device md5.
>ext3_abort called.
>EXT3-fs error (device md5): ext3_journal_start_sb: Detected aborted jo=
urnal
>Remounting filesystem read-only
>EXT3-fs error (device md5) in start_transaction: Journal has aborted
=2E... snip ....
=2E... snip ....
>EXT3-fs error (device md5) in start_transaction: Journal has aborted
>
>After this I have to do a filesystem check and the 2.4.18 kernel repor=
ts a dirty RAID and
>starts the resync...
>
>Does anybody have an idea?
>What's the cause of this???
>
>Is there an known bug in the 2.6.10?
>Is the Software RAID in the 2.6 series stable?
>
>Any special kernel compile options not to use when using RAID?
>Any other (better) test to do?
>
>Regards
>~ Sven
>
>~ Sven Anders <anders@anduras.de>
>
>~ ANDURAS service solutions AG
>~ Innstra=DFe 71 - 94036 Passau - Germany
>~ Web: www.anduras.de - Tel: +49 (0)851-4 90 50-0 - Fax: +49 (0)851-4 =
90 50-55
>
>Rechtsform: Aktiengesellschaft - Sitz: Passau - Amtsgericht Passau HRB=
 6032
>Mitglieder des Vorstands: Sven Anders, Marcus Junker, Michael Sch=F6n
>Vorsitzender des Aufsichtsrats: Dipl. Kfm. Karlheinz Antesberger
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
