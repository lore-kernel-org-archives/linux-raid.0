From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Good news / bad news - The joys of RAID
Date: Mon, 22 Nov 2004 12:51:04 -0500
Message-ID: <200411221751.iAMHpAN32404@www.watkins-home.com>
References: <Pine.LNX.4.56.0411221429380.4195@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0411221429380.4195@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: 'Gordon Henderson' <gordon@drogon.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yes, I was going for affordable!  A tape drive with native capacity of =
160
Gig costs over $2600 US (SDLT).  And tapes cost $89 each.  You need to =
do a
lot of backups before tapes cost less than an IDE disk.  An IDE disk is=
 so
much faster too.

The best price I could find for a 160Gig ultra 100 was $107 Hitachi
A Hitachi 160 Gig SATA disk is $113.

SDLT tapes cost $89 each (10 for $890)

I am sure you could get a quantity discount on tapes, but disk drives t=
oo.

Now we just need to be able to hot plug ultra 100 disk drives.
SATA hardware supports hot plug, but I read Linux does not support that=
 yet.

I do want to be able to remove my backup and put it in the shelf.  A
business should have 2 copies where one goes off site.  I did have a po=
wer
supply fail in a way that it fried everything in the box.  I think line
voltage was send directly to the 12V or 5V line.  DVD drive, disk drive=
,
motherboard, RAM, video card, ... all gone.   So if my backups were on-=
line
with the same power supply as the main disk(s), all would have been los=
t.

Some people seem to think tape is better than disk.  Somehow since ther=
e is
no filesystem, so you can't delete a file by mistake.  So, fine, just u=
se
the disk drive the same way.  Use cpio and output to /dev/hda or simila=
r.
The only thing tapes have that is better than disk drives is the eof an=
d eot
marks.  I can put 10-20 daily backups on the same tape and let the hard=
ware
track the position of each backup.  With disk, you would need to count =
the
blocks used, and track the start and length of each.  Or you could use =
a
file system, but like I said, some people seem to think that has too mu=
ch
risk.

Guy

-----Original Message-----
=46rom: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Gordon Henderson
Sent: Monday, November 22, 2004 9:35 AM
To: linux-raid@vger.kernel.org
Subject: RE: Good news / bad news - The joys of RAID

On Mon, 22 Nov 2004, Yu Chen wrote:

> > Now if someone made an affordable tape drive and tapes that could b=
ackup
> > 200G per tape, that would be cool!
>
> You don't know? they have that already, AIT-4, LTO as I know.

I think the key-word here was "affordable"

I use DLT drives, which I think go up to 220GB native right now, ('m on=
ly
currently using 160GB native drives), but right now the cost of media a=
t
about =A360 each is about the same as a 160GB IDE drive.. Easier to man=
age
though, and the cost of the tape drive is still round about =A33500.

But how valuable is your data? (As I keep telling my clients!!!)

I've tried to build servers that have a max. capacity of 200GB per
partition, but I have clients chomping at the bit for bigger partitions=
,
thn it becomes a PITA to backup to tape.

I don't think the requirement for tape backup is going to go away in th=
e
near future, anyway. I just wish tape technology would keep up with dis=
k
technology.

RAID is great, but it's not for archive and backup.

Gordon
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
