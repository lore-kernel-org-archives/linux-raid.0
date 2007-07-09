From: "Daniel Korstad" <dan@korstad.net>
Subject: RE:  Software based SATA RAID-5 expandable arrays?
Date: Mon, 9 Jul 2007 14:31:01 -0500
Message-ID: <195733459.1184009461155.JavaMail.root@gateway.korstad.net>
References: <944875.74303.qm@web54106.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <944875.74303.qm@web54106.mail.re2.yahoo.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Michael <big_green_jelly_bean@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You have lots of options.  This will be a lengthy response and will giv=
e just some ideas for just some of the options...
=20
=46or my server, I had started out with a single drive.  I later migrat=
ed to migrate to a RAID 1 mirror (after having to deal with reinstalls =
after drive failures I wised up).  Since I already had an OS that I wan=
ted to keep, my RAID-1 setup was a bit more involved.  I following this=
 migration to get me there;
http://wiki.clug.org.za/wiki/RAID-1_in_a_hurry_with_grub_and_mdadm
=20
Since you are starting from scratch, it should be easier for you.  Most=
 distros will have an installer that will guide you though the process.=
  When you get to hard drive partitioning, look for an advance option o=
r review and modify partition layout option or something similar otherw=
ise it might just make a guess of what you want and that would not be R=
AID.  In this advance partition setup, you will be able to create your =
RAID.  First you make equal size partitions on both physical drives.  F=
or example, first carve out 100M partition on each of the two physical =
OS drives, than make a RAID 1 md0 with each of this partitions and than=
 make this your /boot.  Do this again for other partitions you want to =
have RAIDed.  You can do this for /boot, /var, /home, /tmp, /usr.  This=
 is can be nice to have a separations incase a user fills /home/foo wit=
h crap and this will not effect other parts of the OS, or if mail spool=
 fills up, it will not hang the OS.  Only problem it determining how bi=
g to make them during the install.  At a minimum, I would do three part=
itions; /boot, swap, and /  This means all the others (/var, /home, /tm=
p, /usr) are in the / partition but this way you don't have to worry ab=
out sizing them all correctly.=20
=20
=46or the simplest setup, I would do RAID 1 for /boot (md0), swap (md1)=
, and / (md2)  (Alternatively, your could make a swap file in / and not=
 have a swap partition, tons of options...)  Do you need to RAID your s=
wap?  Well, I would RAID it or make a swap file within a RAID partition=
=2E  If you don't and your system is using swap and you lose a drive th=
at has swap information/partition on it, you might have issues dependin=
g on how important that information in the failed drive was.  You syste=
ms might hang.
=20
After you go through the install and have a bootable OS that is running=
 on mdadm RAID, I would test it to make sure grub was installed correct=
ly to both the physical drives.  If grub is not installed to both drive=
s, and you lose one drive down the road and if that one was the one wit=
h grub, you will have a system that will not boot even though it has a =
second drive with a copy of all the files.  If this were to happen, you=
 can recover by booting with a bootable linux CD or recover disk and ma=
nually installing grub too. For example say you only had grub installed=
 to hda and it failed, boot with a live linux cd and type (assuming /de=
v/hdd is the surviving second drive);
grub
 device (hd0) /dev/hdd
 root (hd0,0)
 setup (hd0)
 quit
You say you are using two 500G drives for the OS.  You don't necessary =
have to use all the space for the OS.  You can make your partitions and=
 take the left over space and throw it into a logical volume.  This log=
ical volume would not be fault tolerant, but would be the sum of the le=
ft over capacity from both drives.  For example, you use 100M for /boot=
 and 200G for / and 2G for swap.  Take the rest and make a standard ext=
3 partition for the remaining space on both drives and put them in a lo=
gical volume giving over 500G to play with for non critical crap.
=20
Why do I use RAID6?  For the extra redundancy and I have 10 drives in m=
y arrary. =20
I have been an advocate for RAID 6, especially with the every increasin=
g drive capacity and the number of drives in the array is above say six=
;
http://www.intel.com/technology/magazine/computing/RAID-6-0505.htm=20
=20
http://storageadvisors.adaptec.com/2005/10/13/raid-5-pining-for-the-fjo=
rds/=20
"...for using RAID-6, the single biggest reason is based on the chance =
of drive errors during an array rebuild after just a single drive failu=
re. Rebuilding the data on a failed drive requires that all the other d=
ata on the other drives be pristine and error free. If there is a singl=
e error in a single sector, then the data for the corresponding sector =
on the replacement drive cannot be reconstructed. Data is lost. In the =
drive industry, the measurement of how often this occurs is called the =
Bit Error Rate (BER). Simple calculations will show that the chance of =
data loss due to BER is much greater than all the other reasons combine=
d. Also, PATA and SATA drives have historically had much greater BERs, =
i.e., more bit errors per drive, than SCSI and SAS drives, causing some=
 vendors to recommend RAID-6 for SATA drives if they=E2=80=99re used fo=
r mission critical data."
=20
Since you are using only four drives for your data array, the overhead =
for RAID6 (two drives for parity) might not be worth it. =20
=20
With four drives you would be just fine with a RAID5.
However, I would make a cron for the command to run every once in awhil=
e.  Add this to your crontab...

#check for bad blocks once a week (every Mon at 2:30am)if bad blocks ar=
e found, they are corrected from parity information=20
30 2 * * Mon echo check /sys/block/md0/md/sync_action
=20
With this, you will keep hidden bad blocks to a minimum and when a driv=
e fails, you won't be likely bitten by a hidden bad block(s) during a r=
ebuild.
=20
=46or your data array, I would make one partition of Linux raid (FD) an=
d have one partition for the whole drive in each physical drive.  Than =
create your raid. =20
=20
mdadm --create /dev/md3 -l 5 -n 4 /dev/<your data drive1-partition> /de=
v/<your data drive2-partition> /dev/<your data drive3-partition> /dev/<=
your data drive4-partition>  <---the /dev/md3 can be what you want and =
will depend on how many other previous raid arrays you have, so long as=
 you use a number not currently used. =20
=20
My filesystem of choice is XFS, but you get to pick your own poison:
mkfs.xfs /-f /dev/md3
=20
Mount the device :
mount /dev/md3 /foo
=20
I would edit your /etc/fstab to have it automounted for each startup.
=20
Dan.
=20
----- Original Message -----
=46rom: Michael=20
Sent: Sun, 7/8/2007 3:54pm
To: Daniel Korstad=20
Subject: Re: Software based SATA RAID-5 expandable arrays?
=20
=20
Hey Daniel,

Time for business... been struggling the last few days setting up the r=
ight drive/OS partition
I got two 500gb drives for the OS... Figured I would mirror them...  Of=
 course 500gb is an insaine amount of space for Linux...
I then will RAID my 4 other drives with RAID 5 or 6...  (I havent seen =
any distros talk about RAID 6, and from wikipedia it doesnt sound attra=
ctive, so why do you use it)

So how the hell do I partition this so that I can use my space to the m=
aximum compacity.




----- Original Message ----
=46rom: Daniel Korstad <dan@korstad.net>
To: big_green_jelly_Bean@yahoo.com
Cc: linux-raid@vger.kernel.org
Sent: Monday, June 18, 2007 8:46:08 AM
Subject: RE: Software based SATA RAID-5 expandable arrays?


Last I check expanding drives (reshaping the RAID) in a raid set within=
 Windows is not supported.

Significant size is relative I guess, but 4-8 terabytes will not be a p=
roblem in either OS.

I run a RAID 6 (Windows does not support this either last I checked).  =
I started out with 5 drives and have reshaped it to ten drives now.  I =
have a few 250G (old original drives) and many 500G drives (added and r=
eplacement drives) in the set.  Once all the old 250G die off and I rep=
lace them with 500G drives I will grow the RAID to the size of its new =
smallest disk, 500G.  Grow and Reshape are slightly different, both sup=
ported in Linux mdadm.  I have tested both with succcess.

I too use my set for media and it is not in use 90% of the time.

I use put this line in my /etc/rc.local to put the drives to sleep afte=
r a specified min of inactivity;
hdparm -S 241 /dev/sd*
The values for the -S switch are not intuitive, read the man page.  The=
 value I use (241) put them to standby (spindown) after 30min.  My OS i=
s on EIDE and my RAID set is all SATA, hence the splat for all SATA dri=
ves.=20

I have been running this for a year now with my RAID set.  It works gre=
at and I have had no problems with mdadm waiting on drives to spinup wh=
en I access them.

The one caveat, be prepared to wait a few moments if the are all in spi=
ndown state before you can access your data.  For me with ten drives, i=
t is always less than a minute, usually 30sec or so.

=46or a filesystem, I use XFS for my large media files.

Dan.




----- Inline Message Follows -----
To: linux-raid@vger.kernel.org
=46rom: greenjelly
Subject: Software based SATA RAID-5 expandable arrays?


I am researching my option to build a Media NAS server.  Sorry for the =
long
message, but I wanted to provide as much details as possible to my prob=
lem,
for the best solution.  I have Bolded sections as to save people who do=
n't
have the time to read all of this.

Option 1: Expand My current Dream Machine!
I could buying a RAID-5 Hardware card for my current system (vista ulti=
mate
64 with a extreme 6800 and 1066mb 2 gig RAM).  The Adaptec RAID control=
ler
(model "3805", you can search NewEgg for the infomation) will cost me n=
ear
$500 (consume 23w) and support 8 drives (I have 6).  This controller
contains a 800mhz processor with a large cache of memory.  It will supp=
ort
expandable RAID-5 array!  I would also buy a 750w+ PSU (for the additio=
nal
safety and security).  The drives in this machine would be placed in sh=
ock
absorbing (noise reduction) 3 slot 4 drive bay containers with fans ( I=
 have
2 of these) and I will be removing a IDE based Pioneer DVD Burner (1 of=
 3)
because of its flaky performance given the p965 intel chip set lack of
native IDE support and thus the Motherboards Micron SATA to IDE device.=
  Ive
already installed 4 drives in this machine (on the native MB SATA
controller) only to find a fan fail on me within days of the installati=
on.=20
One of the drives went bad (may or may not have to do with the heat).  =
There
are 5mm between these drives, and I would now replace both fans with hi=
gher
RPM ball baring fans for added reliability (more noise).  I would also =
need
to find a Freeware SMART monitor software which at this time I can not =
find
for Vista, to warn me of increased temps due to failure of fan, increas=
ed
environmental heat, etc.  The only option is commercial SMART monitorin=
g
software (which may not work with the Adaptec RAID adapter.

Option 2: Build a server.
I have a copy of Windows 2003 server, which I have yet to find out if i=
t
supports native software expandable RAID-5 arrays.  I can also use Linu=
x
(which I have very little experience with) but have always wanted to us=
e and
learn.=20

To do either of the last two options, I would still need to buy a new p=
ower
supply for my current VISTA machine (for added reliability).  The curre=
nt
PSU is 550w and with a power hungry RADEON, 3 DVD Drives and a X-Fi sou=
nd
card... My nerves are getting frayed.=20

I would buy a cheap motherboard, processor and 1gig or less of RAM.  La=
stly
I would want a VERY large Case.  I have a 7300 NVidia PCI card that was
replaced with a X1950GT on my Home Theater PC so that I may play back
HD/Blue Ray DVD's.

The server option may cost a bit more then the $500 for the Adaptec Rai=
d
controller.  This will only work if Linux or Windows 2003 supports my m=
uch
needed requirements.  My Linux OS will be installed on a 40mb IDE Drive=
 (not
part of the Array). =20

The options I seek are to be able to start with a 6 Drive array RAID-5
array, then as my demand for more space increases in the future I want =
to be
able to plug in more drives and incorporate them into the Array without=
 the
need to backup the data.  Basically I need the software to add the
drive/drives to the Array, then Rebuild the array incorporating the new
drives while preserving the data on the original array.

QUESTIONS
Since this is a media server, and would only be used to serve Movies an=
d
Video to my two machines It wouldn't have to be powered up full time (M=
y
Music consumes less space and will be contained on two seperate machine=
s).=20
Is there a way to considerably lower the power consumption of this serv=
er
the 90% of time its not in use?

Can Linux support Drive Arrays of Significant Sizes (4-8 terabytes)?

Can Linux Software support RAID-5 expandability, allowing me to increas=
e the
number of disks in the array, without the need to backup the media, rec=
reate
the array from scratch and then copy the backup to the machine (somethi=
ng I
will be unable to do)?

I know this is a Linux forum, but I figure many of you guys work with
Windows Server.  If so does Windows 2003 provide the same support for t=
he
requested requirements above?

Thanks
GreenJelly
--=20
View this message in context: http://www.nabble.com/Software-based-SATA=
-RAID-5-expandable-arrays--tf3937421.html#a11167521
Sent from the linux-raid mailing list archive at Nabble.com.

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html






_______________________________________________________________________=
_____________
We won't tell. Get more on shows you hate to love=20
(and love to hate): Yahoo! TV's Guilty Pleasures list.
http://tv.yahoo.com/collections/265
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
