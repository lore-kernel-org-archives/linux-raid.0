From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Cheap NAS RAID device
Date: Mon, 5 May 2003 09:07:11 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.43.0305050841380.18894-100000@unicorn.drogon.net>
References: <200305041645.19097.nesta@iceburg.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200305041645.19097.nesta@iceburg.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 4 May 2003, Brice B wrote:

> I'm currently trying to build myself a *home* fileserver w/ the
> following requirements:
>
> 1) Small, portable & durable
> 2) At least 240GB (maintain scalability)
> 3) Must be redundant (RAID 1 or 5)
> 4) Cannot exceed $850
>
>  The basic application of the device will be to hold backed up data, =
and
> to serve ogg/mp3 files.
>
>  So far I haven't been able to find any 1U NAS turn-key raid solution=
 for
> anything under $2000 for just the chasis! So this thing is going to h=
ave to
> be hacked together, and this is what I've come up with:

There are solutions to be had, I guess it just means looking further fo=
r
them - eg.from memory, http://www.bitenet.co.uk/hardware1.ihtml?id=3D4 =
sell
some boxes in the =A31400 range plus whatever drives you put in them. B=
ut
these guys are located in the UK...

> 1 EPIA MB w/ VIA C3 800mhz Processor (mini ITX)
> A tailored case [ likely out of a tape deck ]
> 3 120GB IDE drives
> [Possilbe Raid Controller]
> Linux [ 2.4 or 2.5 kernel ] w/ NFS, apache, samba
>
>  My ?'s are:
>
>  Will the performance of a linux software raid level 5 be sufficient =
w/
> the VIA C3 800mhz Processor?

Probably. You need to look where the bottlenecks are. If you hang 2 dri=
ves
off teh same controller then you won't get as good a performance as if
you'd hung the drives off an individual controller. Theres also a big g=
rey
area about a disk failing too - I've heard that if a disk fails then it
has a good chance of taking out the other drive on that controller
(hopefully just rendering it unusable until the failed disk is removed,
rather than actually trashing it) I've not done any experiments myself
though.

So you might be better off with 2 x PCI dual controllers and 4 80GB dis=
ks
as as master devices off the cards.

As you seem to have found, 1U cases carry a premium! If you can get awa=
y
with it, you might be better off with a (mini) Tower. Stick as much mem=
ory
in it as you can afford and if possible get a processor with as big a
cache as possible

Heres one I built earlier:

gordonh @ blue: uname -a
Linux blue 2.4.20-ac2 #1 SMP Fri Dec 13 17:09:21 GMT 2002 i686 unknown

gordonh @ blue: df -h -F ext2
=46ilesystem            Size  Used Avail Use% Mounted on
/dev/md0              235M   73M  150M  33% /
/dev/md1              1.4G  645M  718M  48% /usr
/dev/md2              5.6G  4.3G  1.1G  80% /var
/dev/md3              111G   89G   16G  85% /mounts/idrive
/dev/md4              111G   83G   22G  79% /mounts/idrive.yesterday
/dev/md5              111G   91G   14G  86% /mounts/idrive.dby

gordonh @ blue: cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid5]
read_ahead 1024 sectors
md0 : active raid1 hdi1[1] hde1[0]
      248896 blocks [2/2] [UU]

md1 : active raid5 hdk2[3] hdi2[1] hdg2[2] hde2[0]
      1493760 blocks level 5, 32k chunk, algorithm 0 [4/4] [UUUU]

md2 : active raid5 hdk3[3] hdi3[1] hdg3[2] hde3[0]
      6000000 blocks level 5, 32k chunk, algorithm 0 [4/4] [UUUU]

md3 : active raid5 hdk5[3] hdi5[1] hdg5[2] hde5[0]
      117860544 blocks level 5, 32k chunk, algorithm 0 [4/4] [UUUU]

md4 : active raid5 hdk6[3] hdi6[1] hdg6[2] hde6[0]
      117860544 blocks level 5, 32k chunk, algorithm 0 [4/4] [UUUU]

md5 : active raid5 hdk7[3] hdi7[1] hdg7[2] hde7[0]
      117860544 blocks level 5, 32k chunk, algorithm 0 [4/4] [UUUU]

unused devices: <none>


This has half a gig of RAM and dual athlons.(which personally I think i=
s
overkill, but I didn't spac. the hardware for this one, just installed =
the
software)  It boots off a RAID 1 (Mirrored) and all the other partition=
s
are RAID5. I can sustain over 26MB/sec writing to it and over 50MB/sec
reading which is faster than can be had through a single Ethernet
interface, so I'm happy. It serves a small silicon design company via N=
=46S
and Samba (they have about hanf a dozen servers similar to this, all
running software raid)

>  Will the data be safe under LSR? ie. If a disk dies, will I be warne=
d?
> When I shutdown & replace the disk, will data remain?

You'll be warned if you are running a deamon that checks the system. I'=
ve
been using s/w RAID for over 3 years now but not looked at MADM yet. I
have cobbled some stuff together to poll /proc/mdstat and send email.

When you replace a failed disk, it should rebuild itself, but you'll ha=
ve
to partition it in the same way as the failed disk, so keep a note of t=
he
partition table, or, if this is a high reliabiltiy system, buy one more
disk and partition it up at build time and keep it by the machine,
cold-spare as it were.

I'm personally not happy about hot-swapping an IDE drive anyway and hav=
e
always powered down a PC when changing an IDE drive. (Which has only
happend once in the time I've been using s/w/ RAID with IDE drives, but
I've had 2 SCSI drives fail on one server with 8 SCSI disks in 3 years)

>  Am I better off using a 3Ware Escalade or a Promise FastTrax SX4000 =
to
> handle my array?

I've no experience with these - if they work with the kernel then it mi=
ght
be easier to setup if they supply the various utility programs to work
under Linux.

>  Will I have to have a 4th HD to boot off of.. or can I create a cust=
om
> bootable CD that will bring up my system (kernel, raid, apache, nfs,
> samba) ? Or should I boot directly from RAID?

Theres no need to - you might be better off using a RAID1 (mirror) on 2=
 of
the devices, but depending on your distribution that might be tricky to
setup. I know it's easy with RedHat, but I use Debian for all my server=
s
and it's a little harder to do.


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
