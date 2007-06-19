From: "Daniel Korstad" <dan@korstad.net>
Subject: RE:  Software based SATA RAID-5 expandable arrays?
Date: Tue, 19 Jun 2007 13:49:14 -0500
Message-ID: <629734316.1182278954077.JavaMail.root@gateway.korstad.net>
References: <335871.82002.qm@web54105.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <335871.82002.qm@web54105.mail.re2.yahoo.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Michael <big_green_jelly_bean@yahoo.com>, Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

=20
I see nothing wrong with background info if it is relevant.  I am alway=
s interested in learning and not afraid to ask those green newbie quest=
ions, I too was there.  I might not be as green as I once was but I am =
not an expert on everything, always learning and occasionally still ask=
 to green questions.  If I never explored out of my comfort zone I won=E2=
=80=99t continue to learn.  Given I have time; I enjoy parting my exper=
iences with others that have an interest.
=20
I think this is a great forum I have received lots of answers and info =
from both searching archives and asking directly.
=20
If there are some ruffled feathers, I apologize, but I don't care to he=
ar the bashing.  Please don't cc the group; I would rather it be emails=
 just between the individuals with the concerns.
=20
As for as looking for more information or answers, I think there are ma=
ny in the group willing to help out.  But if we don't know what is desi=
red or a more direct question we may not know what response is desired.=
  It is not that the group is ignoring someone.
=20
Now (rolling up sleeves...),=20
As for as the distro.  You could ask 10 unix/linux guys and you would l=
ikely get 10 different answers.  There are heated debates on this all t=
he time.  I have played with a few, not all, so I can tell you what my =
experiences are.  Ubuntu is great for new Linux users.  I have used thi=
s for one of my laptops and have set it up for my folks.  I originally =
cut my teeth on RedHat long before Fedora was spun off from it.  Curren=
tly I run my home server with Fedora Core 4.  The most recent version i=
s Fedora 7 (they dropped the core part).  Distro Watch http://distrowat=
ch.com/ is a good place to look for more info on different versions.  M=
ost of them will have several forums that would be available to you if =
you need to look for help unique to that distro.
=20
To expand the array, you will need a recent kernel.  RAID 5 reshape has=
 been out for some time.  Any distro you chose that is current will pro=
vide what you need.  RAID6 reshape was recently added in 2.6.21.  It wa=
s release a few weeks ago.  The latest stable is 2.6.21.5.  This site h=
as the vanilla kernel http://www.kernel.org/. =20
=20
When you pick a distro, they of course use the linux kernel but it is o=
ften a cooked version, certain tweaks or patches applied that that dist=
ro maintainers feel are appropriate to the users.  Because of this, van=
illa kernels are release prior to it being available to an update manag=
er for that distro.  Oh and update manager vary from between distros as=
 well.  Taking a quick look on an update mirror for Fedora 7, I see ker=
nel-2.6.21-1.3228.fc7.i586.rpm so if you did an install for Fedora 7 th=
an did a yum update to freshen all the packages you will get the requir=
ed kernel to support RAID 6 reshape as well.  Other distros might have =
the 2.6.21 available as well, if they don't, they will soon using their=
 update manager.  So you should not need to do any kernel recompile for=
 a newer distro version.  I had to because my version of Fedora is very=
 old and end of service.  They are not releasing new updates for me.   =
That might be another item to consider, Fedora stops providing updates =
for version that are 2 releases below the current one.  So Fedora 7 is =
the latest, 6 is still supported.  When version 8 is released, 7 will b=
e support and 6 will be dropped.  Fedora has a rapid development timeta=
ble, a couple releases a year.  Other distros might (probably do) have =
a longer life cycle.
=20
=46or building your raid, there are lots of options and variations.  I =
can tell you some basic steps I used.
=20
I use the available slots on my motherboard and added a couple PCI card=
s to get me to a 10 disk array.  You will have a newer system and using=
 PCI-express cards.  As for a recommendation, I would have to defer tha=
t to someone else.  I have not upgraded my system to PCI-express yet.  =
Most of the cards with several SATA ports will have more features then =
needed for software RAID.  They have their own RAID which jacks up cost=
 and it is not needed.  I too would be curious to hear what others are =
using as I will need to update my system at some point.
=20
=46or my RAID set, I made a partition on each of my sata drives.  I tha=
n marked them are type Linux Raid in the fdisk utility... Ummm what a m=
in, here is a link I found from a google search the closely resembles t=
he same steps I took years ago when I built the raid set I am using;
=20
http://www.linuxhomenetworking.com/wiki/index.php/Quick_HOWTO_:_Ch26_:_=
Linux_Software_RAID
=20
 =20
To reshape, add drives to your raid set in the future, you first add th=
e new drive to the existing raid set.
=20
mdadm --add /dev/md0 /dev/sdf1
=20
Next use the --grow switch to reshape it to the new number of drives yo=
u want.  The command below assumes you had 3 devices in the raid set be=
fore you added sdf1 and now after you added sdf1 to be available to the=
 set, you want the raid-devices to be 4.  Next time you add a device, i=
t would be 5 ...=20

mdadm --grow /dev/md0 --raid-devices=3D4
=20
=20
The filesystem then needs to be expanded to fill up the new space, for =
ext3
fsck.ext3 /dev/md0
resize2fs /dev/md0
=20
=46or XFS
xfs_growfs /dev/md0
=20
Cheers,
Dan.
=20
----- Original Message -----
=46rom: Michael=20
Sent: Tue, 6/19/2007 8:44am
To: Dexter Filmore ; David Greaves ; Daniel Korstad=20
Cc: linux-raid@vger.kernel.org
Subject: Re: Software based SATA RAID-5 expandable arrays?=20
=20
=20
Look at your sig...


--=20

-----BEGIN GEEK CODE BLOCK-----

Version: 3.12

GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-

w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@=20

b++(+++) DI+++ D- G++ e* h>++ r* y?

------END GEEK CODE BLOCK------



http://www.stop1984.com

http://www.againsttcpa.com



You should get out more, maybe learn to interact with people.  Its sad =
that my post could effect you the way it did.  You have    Slinging ins=
ults has done nothing to provide a solution to my build, and has distra=
cted from the quality of this forum.  Maybe someone can recommend a dif=
ferent Linux Forum that is better moderated and/or not filled with a pe=
rson so near sighted that I cant get a solution due to the fact that th=
ings tend to deteriorate into flame wars.  Dexter why must you focus on=
 information sharing as being negative. =20

Am I proud of my gaming/work machine... absolutely... Just like I'm pro=
ud of my car and house.  Did I share this info to brag to people on a R=
AID Linux forum?  Absolutely not... Thats what OCForums is for:)  I pro=
vided this information as to the reasons why I decided to build a separ=
ate machine, and to provide information on what resources I have.  A gr=
eat example is the idea to pull my  550w PSU from my work horse and pla=
ce it into my NAS machine.  I also was hoping for someone to come up wi=
th a unorthodox solution, that may save me money. =20

This forum doesn't seem to be a place for answers, though I really appr=
eciate the instructions from Daniel Korstad on how to put the drives to=
 sleep.  I have created a mail folder for such great responses. I have =
yet to get info on what build and/or distro I should use.  What command=
s I need in Linux to build an array.  What commands I need in Linux to =
expand the array, and what type of RAID-5 setup linux option I should u=
se to   What SATA adapter cards I should use.  Or any other ideas and s=
uggestions.

Thanks Dexter for providing an environment where such info is unobtaina=
ble.

GreenJelly

PS  The reason I use my Alias is the fact that their are socially inept=
, super critical, highly judgmental individuals who see asking for help=
, as begin a weakness.  Or simply individuals who like to tear you down=
 because you don't do things like they feel should be done.









      =20
_______________________________________________________________________=
_____________
Moody friends. Drama queens. Your life? Nope! - their life, your story.=
 Play Sims Stories at Yahoo! Games.
http://sims.yahoo.com/
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
