From: Jens Benecke <jens@spamfreemail.de>
Subject: Q: RAID-1 w/2x160GB, ReiserFS, Debian "woody", homebrew 2.4.25 kernel
Date: Wed, 04 Aug 2004 10:42:59 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <ceq7ij$vj7$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi everybody,

I'm planning to set up a new RAID mirrored system with the above specs.=
 Both
disks are master (hda and hdc). I'm currently trying to decide between =
LVM2
(is it in 2.4 already?), MD, and a "manual" nightly rsync onto the seco=
nd
disk.

I'd like a few pointers (RTFwhatever welcome) to the following question=
s:


How about RAIDing the root partition? If one drive fails will the other=
 be
able to boot via LILO? How about GRUB? Which do you prefer?

How about (/var)/tmp? I (suppose I'll) need it on both disks, does it m=
ake
sense to mirror it as well?

Can I mirror the whole disk? Or do I need to mirror each partition
seperately?

Does MD or LVM2 do hot sync, i.e. if one drive fails will I be able to =
stick
in a replacement, and stop worrying? Or do I need to repartition the ne=
w
disk exactly as the old one, before being able to sync?

How does LVM2/MD deal with failing harddisks, which is why I do the mir=
ror
at all? I've heard about MD not detecting read errors because the "othe=
r"
disk was reading fine, and crashing completely when one disk was finall=
y
replaced because the data on the other disk was also corrupt. Is that s=
till
the current case?


The goal is to have as "stress free" a system as possible - i.e. with a=
s
little manual configuration, and in event of emergencies, as little wor=
k to
do, as possible.


Thank you for your help!


--=20
Jens Benecke
http://www.hitchhikers.de - Europas kostenlose Mitfahrzentrale seit 199=
8
http://www.rb-hosting.de - Webhosting mit Extras - PHP ab =A49 - SSH ab=
 =A419
http://www.spamfreemail.de - 100% saubere Postf=E4cher, garantiert!

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
