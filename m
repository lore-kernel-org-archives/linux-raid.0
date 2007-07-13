From: Michael <big_green_jelly_bean@yahoo.com>
Subject: Re: Software based SATA RAID-5 expandable arrays?
Date: Fri, 13 Jul 2007 09:48:05 -0700 (PDT)
Message-ID: <827606.43281.qm@web54104.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Korstad <dan@korstad.net>
Cc: davidsen <davidsen@tmr.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

RESPONSE

I had everything working, but it is evident that when I installed SuSe
the first time check and repair where not included in the package:(  I
did not use the ">>" I used ">", as was incorrectly stated in
many documentations I set up.



The thing that made me suspect check and repair wasn't part of sues was
the failure of "check" or "repair" typed at the command prompt to
respond in any kind other then a response that stated their was no
command.  In addition man check and man repair was also missing.



BROKEN!

I did an auto update of the SuSe machine, which ended up replacing the
kernel.  They added the new entries to the boot choices but the mount
information was not transfered.  SuSe also deleted the original kernel
boot setup.  When suse looked at the drives individually they found
that none of them was recognizable.  Therefor when I woke up this
morning and rebooted the machine after the update, I received the
errors and then dumps me to a basic prompt with limited ability to do
anything.  I know I need to manually remount the drives, but its going
to be a challenge since I did not do this in the past.  The answer to
this question is that I either have to change distro's (which I am
tempted to do) or fix the current distro.  Please do not bother
providing any solutions for I simply have to RTFM (which I haven't had
time to do).



I think I am going to reset up my machines.  The first two drives with
identical boot partitions, yet not mirror them.  I can then manually
run a "tree" copy that would update my second drive as I grow the
system, and after successfull and needed updates.  This would then
allow me a fall back after any updates, and with simply swapping SATA
drive cables from the first boot drive too the second.  I am assuming
this will work.  I then can RAID-6 (or 5) in the setup, recopy my files
(yes I haven't deleted them because I am not confident in my ability
with Linux yet.).  Hopefully I will just simply remount these 4 drives
because there a simple raid 5 array.



SUSE's COMPLETE FAILURES

This frustration with SuSe, the lack of a simple reliable update
utility and the failures I experience has discouraged me from using
SuSe at all.  Its got some amazing tools that help me from constantly
looking up documentation, posting to forums, or going to IRC, but the
unreliable upgrade process is a deal breaker for me.  Its simply to
much work to manually update everything.  This project had a simple
goal, which was to provide an easy and cheap solution to an unlimited
NAS service.



SUPPORT

In addition, SuSe's IRC help channel is among the worst I have
encountered.  The level of support is often very good, but the level of
harassment, flames and simple childish behavior overcomes almost any
attempt at providing any level of support.  I have no problem giving
back to the community when I learn enough to do so, but I will not be
mocked for my inability to understand a new and very in depth system.=20
In fact, I tend to goto the wonderful gentoo irc for my answers.  The
IRC is amazing, the people patient and encouraging, the level of
knowledge is the best I have experienced.  This resource, outside the
original incident, has been an amazing resource.  I feel highly
confident asking questions about RAID here, because I know you guys are
actually RUNNING systems that I am attempting to do.

----- Original Message ----
=46rom: Daniel Korstad <dan@korstad.net>
To: big.green.jelly.bean <big_green_jelly_bean@yahoo.com>
Cc: davidsen <davidsen@tmr.com>; linux-raid <linux-raid@vger.kernel.org=
>
Sent: Friday, July 13, 2007 11:22:45 AM
Subject: RE: Software based SATA RAID-5 expandable arrays?

To run it manually;

echo check >> /sys/block/md0/md/sync_action

than you can check the status with;

cat /proc/mdstat

Or to continually watch it, if you want (kind of boring though :) )

watch cat /proc/mdstat

This will refresh ever 2sec.

In my original email I suggested to use a crontab so you don't need to =
remember to do this every once in a while.

Run (I did this in root);

crontab -e=20

This will allow you to edit you crontab. Now past this command in there=
;

30 2 * * Mon echo >> check /sys/block/md0/md/sync_action

If you want you can add comments, I like to comment my stuff since I ha=
ve lots of stuff in mine, just make sure you have '#' in the front of t=
he lines so your system knows it is just a comment and not a command it=
 should run;

#check for bad blocks once a week (every Mon at 2:30am)
#if bad blocks are found, they are corrected from parity information

After you have put this in your crontab, write and quit with this comma=
nd;

:wq

It should come back with this;
[root@gateway ~]# crontab -e
crontab: installing new crontab

Now you can look at your cron table (without editing) with this;

crontab -l

It should return something like this, depending if you added comments o=
r how you scheduled your command;

#check for bad blocks once a week (every Mon at 2:30am)
#if bad blocks are found, they are corrected from parity information
30 2 * * Mon echo >> check /sys/block/md0/md/sync_action

=46or more info on crontab and syntax for times (I just did a google an=
d grabbed the first couple links...);
http://www.tech-geeks.org/contrib/mdrone/cron&crontab-howto.htm
http://ubuntuforums.org/showthread.php?t=3D102626&highlight=3Dcron

Cheers,
Dan.

-----Original Message-----
=46rom: Michael [mailto:big_green_jelly_bean@yahoo.com]=20
Sent: Thursday, July 12, 2007 5:43 PM
To: Bill Davidsen; Daniel Korstad
Cc: linux-raid@vger.kernel.org
Subject: Re: Software based SATA RAID-5 expandable arrays?

SuSe uses its own version of cron which is different then everything el=
se I have seen, and the documentation is horrible.  However they provid=
e a wonderfull xwindows utility that helps set them up... the problem I=
m having is figuring out what to run.  When I try to run "/sys/block/md=
0/md/sync_action" under a prompt it shoots out a permission denied even=
 though I am SU or logged in under Root.  Very annoying.  You mention C=
heck vrs Repair... which brings me too my last issue on setting up this=
 machine.  How do you send an email when Check, SMART, and when a RAID =
drive fails?  How do you auto repair if the Check fails?

These are the last things I need to do for my Linux Server to work righ=
t... after I get all of this done, I will change the boot to goto the c=
ommand prompt and not XWindows, and I will leave it in the corner of my=
 room hopefully not to be used for as long as possible.

----- Original Message ----
=46rom: Bill Davidsen <davidsen@tmr.com>
To: Daniel Korstad <dan@korstad.net>
Cc: Michael <big_green_jelly_bean@yahoo.com>; linux-raid@vger.kernel.or=
g
Sent: Wednesday, July 11, 2007 10:21:42 AM
Subject: Re: Software based SATA RAID-5 expandable arrays?

Daniel Korstad wrote:
> You have lots of options.  This will be a lengthy response and will g=
ive just some ideas for just some of the options...
> =20
>  =20
Just a few thoughts below interspersed with your comments.
> For my server, I had started out with a single drive.  I later migrat=
ed to migrate to a RAID 1 mirror (after having to deal with reinstalls =
after drive failures I wised up).  Since I already had an OS that I wan=
ted to keep, my RAID-1 setup was a bit more involved.  I following this=
 migration to get me there;
> http://wiki.clug.org.za/wiki/RAID-1_in_a_hurry_with_grub_and_mdadm
> =20
> Since you are starting from scratch, it should be easier for you.  Mo=
st distros will have an installer that will guide you though the proces=
s.  When you get to hard drive partitioning, look for an advance option=
 or review and modify partition layout option or something similar othe=
rwise it might just make a guess of what you want and that would not be=
 RAID.  In this advance partition setup, you will be able to create you=
r RAID.  First you make equal size partitions on both physical drives. =
 For example, first carve out 100M partition on each of the two physica=
l OS drives, than make a RAID 1 md0 with each of this partitions and th=
an make this your /boot.  Do this again for other partitions you want t=
o have RAIDed.  You can do this for /boot, /var, /home, /tmp, /usr.  Th=
is is can be nice to have a separations incase a user fills /home/foo w=
ith crap and this will not effect other parts of the OS, or if mail spo=
ol fills up, it will not hang the OS.  Only problem it
 determining how big to make them during the install.  At a minimum, I =
would do three partitions; /boot, swap, and /  This means all the other=
s (/var, /home, /tmp, /usr) are in the / partition but this way you don=
't have to worry about sizing them all correctly.=20
> =20
> For the simplest setup, I would do RAID 1 for /boot (md0), swap (md1)=
, and / (md2)  (Alternatively, your could make a swap file in / and not=
 have a swap partition, tons of options...)  Do you need to RAID your s=
wap?  Well, I would RAID it or make a swap file within a RAID partition=
=2E  If you don't and your system is using swap and you lose a drive th=
at has swap information/partition on it, you might have issues dependin=
g on how important that information in the failed drive was.  You syste=
ms might hang.
> =20
>  =20
Note that RAID-10 generally performs better than mirroring, particularl=
y=20
when more than a few drives are involved. This can have performance=20
implications for swap, when large i/o pushes program pages out of=20
memory. The other side of that coin is that "recovery CDs" don't seem t=
o=20
know how to use RAID-10 swap, which might be an issue on some systems.
> After you go through the install and have a bootable OS that is runni=
ng on mdadm RAID, I would test it to make sure grub was installed corre=
ctly to both the physical drives.  If grub is not installed to both dri=
ves, and you lose one drive down the road and if that one was the one w=
ith grub, you will have a system that will not boot even though it has =
a second drive with a copy of all the files.  If this were to happen, y=
ou can recover by booting with a bootable linux CD or recover disk and =
manually installing grub too. For example say you only had grub install=
ed to hda and it failed, boot with a live linux cd and type (assuming /=
dev/hdd is the surviving second drive);
> grub
>  device (hd0) /dev/hdd
>  root (hd0,0)
>  setup (hd0)
>  quit
> You say you are using two 500G drives for the OS.  You don't necessar=
y have to use all the space for the OS.  You can make your partitions a=
nd take the left over space and throw it into a logical volume.  This l=
ogical volume would not be fault tolerant, but would be the sum of the =
left over capacity from both drives.  For example, you use 100M for /bo=
ot and 200G for / and 2G for swap.  Take the rest and make a standard e=
xt3 partition for the remaining space on both drives and put them in a =
logical volume giving over 500G to play with for non critical crap.
> =20
> Why do I use RAID6?  For the extra redundancy and I have 10 drives in=
 my arrary. =20
> I have been an advocate for RAID 6, especially with the every increas=
ing drive capacity and the number of drives in the array is above say s=
ix;
> http://www.intel.com/technology/magazine/computing/RAID-6-0505.htm=20
> =20
>  =20
Other configurations will perform better for writes, know your i/o=20
performance requirements.
> http://storageadvisors.adaptec.com/2005/10/13/raid-5-pining-for-the-f=
jords/=20
> "...for using RAID-6, the single biggest reason is based on the chanc=
e of drive errors during an array rebuild after just a single drive fai=
lure. Rebuilding the data on a failed drive requires that all the other=
 data on the other drives be pristine and error free. If there is a sin=
gle error in a single sector, then the data for the corresponding secto=
r on the replacement drive cannot be reconstructed. Data is lost. In th=
e drive industry, the measurement of how often this occurs is called th=
e Bit Error Rate (BER). Simple calculations will show that the chance o=
f data loss due to BER is much greater than all the other reasons combi=
ned. Also, PATA and SATA drives have historically had much greater BERs=
, i.e., more bit errors per drive, than SCSI and SAS drives, causing so=
me vendors to recommend RAID-6 for SATA drives if they=A2re used for mi=
ssion critical data."
> =20
> Since you are using only four drives for your data array, the overhea=
d for RAID6 (two drives for parity) might not be worth it. =20
> =20
> With four drives you would be just fine with a RAID5.
> However, I would make a cron for the command to run every once in awh=
ile.  Add this to your crontab...
>
> #check for bad blocks once a week (every Mon at 2:30am)if bad blocks =
are found, they are corrected from parity information=20
> 30 2 * * Mon echo check /sys/block/md0/md/sync_action
> =20
> With this, you will keep hidden bad blocks to a minimum and when a dr=
ive fails, you won't be likely bitten by a hidden bad block(s) during a=
 rebuild.
> =20
>  =20
I think a comment on "check" vs. "repair" is appropriate here. At the=20
least "see the man page" is appropriate.
> For your data array, I would make one partition of Linux raid (FD) an=
d have one partition for the whole drive in each physical drive.  Than =
create your raid. =20
> =20
> mdadm --create /dev/md3 -l 5 -n 4 /dev/<your data drive1-partition> /=
dev/<your data drive2-partition> /dev/<your data drive3-partition> /dev=
/<your data drive4-partition>  <---the /dev/md3 can be what you want an=
d will depend on how many other previous raid arrays you have, so long =
as you use a number not currently used. =20
> =20
> My filesystem of choice is XFS, but you get to pick your own poison:
> mkfs.xfs /-f /dev/md3
> =20
> Mount the device :
> mount /dev/md3 /foo
> =20
> I would edit your /etc/fstab to have it automounted for each startup.
> =20
> Dan.
> =20
Other misc comments: mirroring your boot partition on drives which the=20
BIOS won't use is a waste of bytes. If you have more than, say four,=20
drives fail to function you probably have a system problem other than=20
disk. And some BIOS versions will boot a secondary drive if the primary=
=20
fails hard but not if it has a parity or other error, which can enter a=
=20
retry loop (I *must* keep trying to boot). This behavior can be seen on=
=20
at least one major server hardware from a big name vendor, it's not jus=
t=20
cheap desktops. The solution, ugly as it is, is to use the firmware=20
"RAID" on the motherboard controller for boot, and I have several=20
systems with low cost small PATA drives in mirror just for boot (after=20
which they are spun down with hdparm settings) for this reason.

Really good notes, people should hang onto them!

--=20
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979







      =20
_______________________________________________________________________=
_____________
Looking for a deal? Find great prices on flights and hotels with Yahoo!=
 FareChase.
http://farechase.yahoo.com/






=20
_______________________________________________________________________=
_____________
Don't pick lemons.
See all the new 2007 cars at Yahoo! Autos.
http://autos.yahoo.com/new_cars.html=20
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
