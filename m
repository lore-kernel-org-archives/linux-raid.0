From: Michael Hardy <mhardy@h3c.com>
Subject: Re: raid and sleeping bad sectors
Date: Wed, 30 Jun 2004 19:42:22 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40E37A0E.90102@h3c.com>
References: <200407010152.i611qo300317@watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200407010152.i611qo300317@watkins-home.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


The last I heard Neil write on the subject (granted I've only been on=20
the list a couple weeks) was that it would just require an alteration i=
n=20
the code to do the auto-write-bad-block-on-read-error.

To me, that read as "submit a patch, if its good, I'll take it"=20
(apologies to Neil if I'm wrong - I'm definitely not qualified to speak=
=20
for him)

I haven't seen anyone disagree with this strategy of trying to force th=
e=20
hardware to remap when you have valid redundant data - and I've asked=20
several people I know off line.

The "plan b" of software-remapping write errors is probably more=20
contentious, but the "plan a" of read error remaps does seem easy and=20
non-controversial.

Its just that no one has stepped up with code.

I don't have the time to do it myself but I too run smartd and it does=20
long tests for me and occasionally reports errors before md finds them,=
=20
so I'd like the solution too. If anyone does code it up and submit an=20
accepted patch, I'd definitely ship a case of beer (or equivalent) thei=
r=20
direction...

-Mike

Guy wrote:
> "And where do you propose the system would store all the info about
> badblocks?"
>=20
> Simple, this is an 8 or 16 bit value per device.  I am sure we could =
find 16
> bits!  If the device is replaced we don't need the info anymore, so s=
tore it
> on the device!  In the superblock maybe?  Once the disk fails it woul=
d be
> nice for md to log the current value, just so we know.
>=20
> About the disk test.  I do a disk test each night.  That's my point!!=
!  I
> don't think I should do the test.  If the test fails I need to correc=
t it.
> Let md test things, and correct them, and send an alert if it can't c=
orrect
> it, or if a threshold is exceeded!
>=20
> Paranoid?  You been using computers long?  I guess not.  In time you =
will
> learn!  :)  If any block in the stripe gets hosed (parity or not) whe=
n you
> replace a disk, during the re-build the constructed data will be wron=
g, even
> if it was correct on the failed disk.  The corruption now affects 2 d=
isks.
> Yes, I want to verify the parity.  Can be just a utility that gives a
> report.  With RAID5 you can't determine which disk is corrupt!  Only =
that
> the parity does not match the data.  If the corruption was in the par=
ity,
> re-writing the parity would correct it.  If the corruption is in the =
data,
> re-writing the parity will prevent spreading the corruption to anothe=
r disk
> during the next re-build.  With RAID6 I think you could determine whi=
ch disk
> is corrupt and correct it!
>=20
> Neil?  Any thoughts?  You have been silent on this subject.
>=20
> Guy
> ---------------------------------------------------------------------=
----
> Spock - "If I drop a wrench on a planet with a positive gravity field=
, I
> need not see it fall, nor hear it hit the ground, to know that it has=
 in
> fact fallen."
>=20
> Guy - "Logic dictates that there are numerous events that could preve=
nt the
> wrench from hitting the ground.  I need to verify the impact!"
>=20
>=20
>=20
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Jure Pe=E8ar
> Sent: Wednesday, June 30, 2004 7:27 PM
> To: linux-raid@vger.kernel.org
> Subject: Re: raid and sleeping bad sectors
>=20
> On Wed, 30 Jun 2004 18:44:16 -0400
> "Guy" <bugzilla@watkins-home.com> wrote:
>=20
>=20
>>I want plan "a".  I want the system to correct the bad block by re-wr=
iting
>>it!  I want the system to count the number of times blocks have been
>>re-located by the drive.  I want the system to send an alert when a l=
imit
>>has been reached.  This limit should be before the disk runs out of s=
pare
>>blocks.  I want the system to periodically verify all parity data and
>>mirrors.  I want the system to periodically do a surface scan (would =
be a
>>side effect of verify parity).
>=20
>=20
> And where do you propose the system would store all the info about
> badblocks?
>=20
> I have an old hw raid controller for my alpha box maintains a badbloc=
k table
> in its nvram. I guess it's a common feature in hw raid cards, since i=
 had a
> whole box of disks with firmwares that reported each internal badbloc=
k
> relocation as scsi hardware error. Needless to say, linux sw raid fre=
aked
> out on each such event. Things were very interesting untill we got fi=
rmware
> upgrade for those disks ...=20
> Also, at least 3ware cards do a 'nightly maintenance' of disks which =
i guess
> is something like dd if=3D/dev/hdX of=3D/dev/null ... What is holding=
 you back
> to do this with a simple shell script and a cron entry?
> Now for cheching the parity in the raid5/6 setups, some kind of tool =
would
> be needed ... maybe some extension to mdadm? For the really paranoid =
people
> out there ... :)
>=20
>=20

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
