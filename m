From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: raid and sleeping bad sectors
Date: Tue, 29 Jun 2004 11:59:06 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200406291559.i5TFx6324611@watkins-home.com>
References: <40E148EF.509@conterra.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40E148EF.509@conterra.de>
To: 'Dieter Stueken' <stueken@conterra.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You are correct.  1 bad sector on a read, the disk is kicked out!
I agree with you, it (md) should not do that!  Your #3 is something I h=
ave
mentioned here a few times.  I don't recall getting any comments!
I get 1 read error about every 3 months or so.  I have 14 disks in a RA=
ID5
array.  Every time I have been able to re-use the same disk.  But it is=
 a
pain in the @$$!  And I worry about a second bad sector!!!

I do a read test of all of my disks each night!  Hoping to catch an err=
or
before md does.  Since a bad sector could go un-noticed for months!  As=
 far
as I know, md does not test the disks any!  As far as I know, md does n=
ot
verify parity.  As far as I know, md does not verify RAID1 data matches=
 on
all disks.

You are also correct.  2 bad sectors on 2 different disks and "That's i=
t
man! Game over man! Game over!".  You may want to consider RAID6.  It w=
ill
allow 2 bad sectors, but not 3!!  I have considered this myself.  I hav=
e 14
disks with a spare.  I should just go with a 15 disk RAID6.

I disagree with your conclusion:  It is normal for a disk to grow bad
sectors.  1 or 2 bad sectors is not an issue.  Maybe 10 or 100 is an is=
sue.
I don't know what the limit should be.  I have maybe 5-10 bad sectors o=
n my
14 disks.  In about 2 years I have not had a hard failure.  I just corr=
ect
the bad sector by hand and re-use the disk.  Maybe I should track which
disks have had bad sectors to determine if there is a pattern, but I do=
n't.
I think md should to this.  I have said so here in the past.

Hardware RAID systems support bad sectors.  Not sure they all do, but s=
ome
or most do.  EMC counts them and when some limit is reached the disk is
copied to a spare.  The "bad" disk is kept on-line.  After all, it is s=
till
working.  I automatic service call is placed to have the "bad" disk
replaced.  I have been told HP's XP-256 does not have a bad sector limi=
t.
They just wait until a disk fails!  Because of this EMC replaces disks =
more
often.  Some see this a EMC has more failures.  I don't see it this way=
=2E
They protect my data better.  Getting off topic I think!....

Guy

-----Original Message-----
=46rom: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Dieter Stueken
Sent: Tuesday, June 29, 2004 6:48 AM
To: linux-raid@vger.kernel.org
Subject: raid and sleeping bad sectors

Question:

Under which conditions a disk of a raid-5 system gets off line?
Does it happen on ANY error, even if some read error happened?
Will double-fault read errors on different disks destroy my
data?

long story:

I manage about 1TB of data on IDE disk and learned
a lot about different kinds of disk failures.
=46ortunately I suffered no data loss so far, as I completely
mirror all data each night (kind of manual raid-1 :-)
I think about using raid-5 now.

My observation was: a sudden total loss of a whole disk
was very unlikely. If you monitor the disk carefully using
its internal SMART capabilities, you are able to copy the
data and replace the disk long time before it finally dies.

see: http://smartmontools.sourceforge.net/

What happens frequently are spontaneous bad sectors, which
can not be read any more (i.e. CRC errors). Most people
think bad sectors are handled automatically by the firmware
of your HD. Unfortunately this is not the whole truth.
Instead of, a bad sector is indicated as bad, until it gets
explicitly rewritten by some new data. At this point, the
HD-firmware may decide to store the new data using a spare
sector instead. The bad news are: sectors turn to become
bad/unreadable quite spontaneously, even if they could be
read successfully short time before!

You may ask, why this is a problem for a raid-5 system?
It is especially designed to handle such problems!
What makes me worry is, that those errors occur spontaneously
and without any notice possibly on several disks simultaneously.
You may detect such a problems only by a complete scan of
all sectors of your disk. The critical question is: what
happens, if the first bad sector on some disk get read.
Does this event kick off that disk from the system?
You may think its a good idea, to kick off the disk as
soon as possible. I think, this may be bad, as it dramatically
decreases the reliability of your remaining system, especially
if you have some other sleeping bad sector on any other disk, too.
At least when you try to rebuild your system, you run into
trouble.

There are several possible solutions. (May be raid systems already
works this way, but I have no experience so far, and I could not
find too much about this in the FAQ or mailing-list)

1) I think a disk should be kept online as long as possible.
This means, that a simple read error should not deactivate the disk
as long the disk can be successfully written to and thus is still in
sync. As long, as "simple" read errors (even on different disks) occur,
my data is still reliable, as it is very unlikely, that two disk fail
with the SAME logical sector number. But it IS likely, that two disk
carry some sleeping bad sectors simultaneously.

2) If I decide to replace a disk, it should be possible to add a new
disk to the system before degrading it. After I successfully build the
new disk, I may switch off the bad one. This way I'm save against multi
disk read errors all time.

example: array of the disks (A B C), want to replace B:

     123456789   <- sector number
A   aaaaaaaXa   <- data on disk a, X =3D unreadable
B   bbXbbbbbb   <- disk b, will be replaced
C   ccccXcccc

B'  bbbbbbbbb   <- new spare disk for b build from current (A,B,C)

3) If a disks happened to produce a bad sector, you may try to rewrite =
it
again, if you still have the data. Using Raid 2 or 5 this is possible, =
as
long as you don't have a double fault on exactly the same sector on any
other disks. For a raid-1/5 system this means it might cure itself!
I did such surgery manually already, and it works quite good.

Conclusion:

After a disk shows up with bad sectors, you should indeed think of repl=
acing
it as soon as possible, but it should not affect data integrity that mu=
ch.
Instead it should be kept alive as long as possible until any necessary
recovery
took place.

Dieter.

--=20
Dieter St=FCken, con terra GmbH, M=FCnster
     stueken@conterra.de
     http://www.conterra.de/
     (0)251-7474-501
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
