From: Jakob Oestergaard <jakob@unthought.net>
Subject: Re: raid 1 vs raid 0+1
Date: Tue, 29 Oct 2002 14:14:53 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021029131453.GB24171@unthought.net>
References: <200210291229.g9TCTcO05488@gg.cyberlab.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210291229.g9TCTcO05488@gg.cyberlab.de>
To: Antonello Piemonte <ap@cyberlab.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 29, 2002 at 01:29:23PM +0100, Antonello Piemonte wrote:
> Hello
>=20
> I have a server wich I would like to set up with
> mirroring for some data protections (against disk failure).
> the machine is supposed to deal mostly with writing of
> lots of small files (2kb perhaps 4kb each) to disk (well, array)
> and the goal would be to be able to write at least few hundreds=20
> files per seconds (!).
>=20
> the question is: for performance, is it better a raid 1 or a=20
> raid 0+1 configuration? is the above load (number of files written
> per second) a realistic goal to attain with a SCSI based uniprocessor=
 PIII=20
> 800MHZ with ext3 file system (this I will tackle separately, perhaps
> will use ext2 to increase performance) and 1 Gig of RAM?=20

On a dual PIII-550 with 512 MB of memory, ext3, and a RAID-0+1 (four 40=
G
7200rpm IBM IDE Deathstar disks, 64k chunk-size on the RAID-0), I get:

$ time for i in {0,1,2,3,4,5,6,7,8,9}; do mkdir $i; for j in
{0,1,2,3,4,5,6,7,8,9}{0,1,2,3,4,5,6,7,8,9}; do dd if=3D/dev/zero of=3D$=
j/$i
bs=3D1k count=3D4; done done

real    0m5.024s

So, 5 seconds for writing one thousand 4 kb files *sequentially*.

Note that I only put 100 files in each directory - if I put 1000 files
in one directory, performance would degrade (more significantly when th=
e
number is, say, 10000).

You may want to experiment with ext3 journalling options - you may see
better performance on data=3Djournal mode, if you write the files in
bursts (with some longer pauses in between).   I cannot give you any
certain advice here, other than to experiment.

RAID-0 will probably allow you to scale better, but I'm really not sure
how the performance on this rather perculiar workload changes as you ad=
d
disks - in any case it will be *highly* filesystem dependent.  You
should definitely also try out ReiserFS and eventually JFS, XFS, and
perhaps even one of the FAT variants (yes, FAT is actually *very* fast
for some very particular workloads, because it is so primitive (eg. it
gets less in the way) - at least this used to be true, but I do not kno=
w
if it is still so, and I'm not sure about your workload either).

So in short; Everything I said here except for the 5 second benchmark i=
s
guessing...  Now you go measure  ;)

Please, if you do decide to measure, do post a summary here to the list=
=2E
I'm sure people will find it interesting, and it will appear in the
archives for the next person with the same problem to find.

Cheers,

--=20
=2E...............................................................
:   jakob@unthought.net   : And I see the elder races,         :
:.........................: putrid forms of man                :
:   Jakob =D8stergaard      : See him rise and claim the earth,  :
:        OZ9ABN           : his downfall is at hand.           :
:.........................:............{Konkhra}...............:
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
