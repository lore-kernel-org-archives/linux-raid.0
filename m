From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: raid and sleeping bad sectors
Date: Wed, 30 Jun 2004 21:52:50 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200407010152.i611qo300317@watkins-home.com>
References: <20040701012719.7b2e16c2.pegasus@nerv.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040701012719.7b2e16c2.pegasus@nerv.eu.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"And where do you propose the system would store all the info about
badblocks?"

Simple, this is an 8 or 16 bit value per device.  I am sure we could fi=
nd 16
bits!  If the device is replaced we don't need the info anymore, so sto=
re it
on the device!  In the superblock maybe?  Once the disk fails it would =
be
nice for md to log the current value, just so we know.

About the disk test.  I do a disk test each night.  That's my point!!! =
 I
don't think I should do the test.  If the test fails I need to correct =
it.
Let md test things, and correct them, and send an alert if it can't cor=
rect
it, or if a threshold is exceeded!

Paranoid?  You been using computers long?  I guess not.  In time you wi=
ll
learn!  :)  If any block in the stripe gets hosed (parity or not) when =
you
replace a disk, during the re-build the constructed data will be wrong,=
 even
if it was correct on the failed disk.  The corruption now affects 2 dis=
ks.
Yes, I want to verify the parity.  Can be just a utility that gives a
report.  With RAID5 you can't determine which disk is corrupt!  Only th=
at
the parity does not match the data.  If the corruption was in the parit=
y,
re-writing the parity would correct it.  If the corruption is in the da=
ta,
re-writing the parity will prevent spreading the corruption to another =
disk
during the next re-build.  With RAID6 I think you could determine which=
 disk
is corrupt and correct it!

Neil?  Any thoughts?  You have been silent on this subject.

Guy
-----------------------------------------------------------------------=
--
Spock - "If I drop a wrench on a planet with a positive gravity field, =
I
need not see it fall, nor hear it hit the ground, to know that it has i=
n
fact fallen."

Guy - "Logic dictates that there are numerous events that could prevent=
 the
wrench from hitting the ground.  I need to verify the impact!"



-----Original Message-----
=46rom: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Jure Pe=E8ar
Sent: Wednesday, June 30, 2004 7:27 PM
To: linux-raid@vger.kernel.org
Subject: Re: raid and sleeping bad sectors

On Wed, 30 Jun 2004 18:44:16 -0400
"Guy" <bugzilla@watkins-home.com> wrote:

> I want plan "a".  I want the system to correct the bad block by re-wr=
iting
> it!  I want the system to count the number of times blocks have been
> re-located by the drive.  I want the system to send an alert when a l=
imit
> has been reached.  This limit should be before the disk runs out of s=
pare
> blocks.  I want the system to periodically verify all parity data and
> mirrors.  I want the system to periodically do a surface scan (would =
be a
> side effect of verify parity).

And where do you propose the system would store all the info about
badblocks?

I have an old hw raid controller for my alpha box maintains a badblock =
table
in its nvram. I guess it's a common feature in hw raid cards, since i h=
ad a
whole box of disks with firmwares that reported each internal badblock
relocation as scsi hardware error. Needless to say, linux sw raid freak=
ed
out on each such event. Things were very interesting untill we got firm=
ware
upgrade for those disks ...=20
Also, at least 3ware cards do a 'nightly maintenance' of disks which i =
guess
is something like dd if=3D/dev/hdX of=3D/dev/null ... What is holding y=
ou back
to do this with a simple shell script and a cron entry?
Now for cheching the parity in the raid5/6 setups, some kind of tool wo=
uld
be needed ... maybe some extension to mdadm? For the really paranoid pe=
ople
out there ... :)


--=20

Jure Pear
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
