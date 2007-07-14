From: "jeff stern" <jas.61803+lr@gmail.com>
Subject: how to deal with continuously getting more errors?
Date: Sat, 14 Jul 2007 11:15:41 -0700
Message-ID: <98d279bf0707141115m14308e64s50f6517b2e1aef5c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi, everyone..  i have a problem.

SUMMARY

i've got a linux software RAID1 setup, with 2 SATA drives (/dev/sdf1,
/dev/sdg1) set up to be /dev/md0. these 2 drives together hold my
/home directories. the / and / partitions are on another drive, a
standard parallel IDE (/dev/hda). (I can provide more hardware
information if someone needs it).

the problem is that new errors (mismatch_cnt discrepancies) between
the two disks keep coming up. weekly. even daily, and i dont know what
to do, or how to handle it.

How many mismatch_cnts between two almost-new drives running in a
healthy RAID1 array should one expect in a year? in a month? a day?

And more importantly, What do i do now?

EXTENDED DESCRIPTION OF PROBLEM

i first noticed this problem when i downloaded the fedora core 7 .iso,
and did a checksum on it, and it didn't match. with a little more
investigating, i found that i could make a copy of any large file on
disk, and its copy would sometimes match, sometimes not.

here is a typical session:
------------------------------------------------------------------------------------------
$ cp F-7-i386-DVD.iso F.iso
$ cmp F-7-i386-DVD.iso F.iso
F-7-i386-DVD.iso F.iso differ: byte 1033827385, line 3789612
$ cmp F-7-i386-DVD.iso F.iso
$ cmp F-7-i386-DVD.iso F.iso
F-7-i386-DVD.iso F.iso differ: byte 1033827385, line 3789612
$ cmp F-7-i386-DVD.iso F.iso
F-7-i386-DVD.iso F.iso differ: byte 8870221, line 37265
$ cmp F-7-i386-DVD.iso F.iso
F-7-i386-DVD.iso F.iso differ: byte 8870221, line 37265
$ _
------------------------------------------------------------------------------------------

as you can see, sometimes the file matches. more often, it doesn't.
when it doesn't, it's not always even at the same point in the file.

this was a bit confusing.

i tried doing these types of file copy/compares in the /tmp directory
(on the /dev/hda drive), and got 0 problems after many attempts.

"Okay," i said to myself, "it's probably not the RAM or the system in
general: it's either the SATA hard drives or it's their controller."

not knowing how to test the serial ATA controller by itself, i decided
to delve into linux software raid and see what i could find.

i went to the linux software raid how-to
(http://tldp.org/HOWTO/Software-RAID-HOWTO.html), but (rather
disappointingly) there was nothing on this problem that i could find
in that document. after several reads.

i also found a linux software raid faq
(http://www.faqs.org/contrib/linux-raid/x37.html), but again, no
reference to these types of problems.

i googled around a bit, and found this group archived at
http://marc.info/?l=linux-raid&r=1&w=2 , and searched and searched
through the messages. i did not find exactly my problem, but i did see
bits and pieces of advice. a couple of these led me to SMART, so i
tested my 2 disks, and found they were/are healthy (at least as far as
they are reporting: when i ran smartctl -t long /dev/sdf1  (and sdg1)
the tests on each drive completed without error. and all the pre-fail
and old-age attributes are fine on these drives (they are less than a
year old so that should not be surprising).

looking at more of the archives, i discovered i could do a couple of
tests. YES! finally, how to diagnose the problem! these tests included
this general regimen, apparently:

1. run
   echo check >> /sys/block/md0/md/sync_action
2. monitor progress with
   watch -n1 'cat /proc/mdstat'
3. afterwards:
   cat /sys/block/md0/md/mismatch_cnt

when i did this, in step 3, i got:

   102656

"over a hundred thousand mismatches?" i thought. "how did THIS happen?
i've had this disk setup for only 6 months! and isn't this RAID!?
aren't these problems supposed to be managed by RAID? what the heck is
going to happen to my data? are my backups fine? or have those been
compromised, too?"

in more reading through the archives, i found that mismatches can
happen, and that indeed linux software raid does not handle them
automatically. furthermore, that several people have found out the
hard way that backups do not help, either, because (in one case, for
months) people found that all they're doing is backing up erroneous
data. LOVELY.


furthermore, i discovered that there was a way to fix them (i.e.,
"sync" the drives). however, this fixing procedure came with a caveat.
 this caveat was something that i should have realized the importance
of in the first place: that a RAID 1 system with only two drives is
going to have a problem when repairing. the problem is that when
sync'ing the drives, whenever a mismatch is found, a decision must be
made as to which drive has the correct data: drive 1 or drive 2? and
that apparently, it's just a toss-up, and the repair program just
picks randomly.

"WHAAAAT????????????"

yeap. so, it's really better to either go with RAID 5, or to have a
RAID 1 system with 3 or more disks.

"gee, sure would have been nice knowing that going in! is that in the HOWTO?"

not really.

(though it's unclear to me that the linux software raid "echo repair"
facility, if faced with 3 (or more drives) would do the "statistics"
and poll all drives and pick the "answer" most commonly given.. would
it?)

so, with this form of repair, if the mismatch is under a jpeg file,
you might get a pixel different. big deal. but if the mismatch is
under your Quicken/GnuCash/Moneydance data files?

"Houston, we have a problem."

well, but what choice did i have?  i made a backup (another supposedly
erroneous one) and took the dive. i followed the posters'
instructions, and attempted a syncing/repair, this way:

4. run
   echo repair >> /sys/block/md0/md/sync_action
5. monitor progress with
   watch -n1 'cat /proc/mdstat'
6. afterwards:
   cat /sys/block/md0/md/mismatch_cnt

now the first time i ran this, i got a mismatch_cnt of

   102656

..which is perfect, because according to the poster's comments, this
means that 102,656 mismatches were REPAIRED. excellent. also,
according to the poster, should i run steps 1,2 & 3 again, i should
*now* see a mismatch_cnt of 0. i did so, and indeed saw 0 mismatches.
Lovely!

also, according to some other posters, linux software raid does not
manage these mismatches, and one should write their own scripts to run
these steps on a regular basis and report on them. (as well as
monitoring smartd's output, as well).

"but wait. if you order now, you also get.."

i did not immediately write scripts, but i waited a week (2 days ago)
and ran steps 1-3 again manually. i found a mismatch_cnt of 512.  "i
got 512 new mismatches in only a week?" i thought. "that's just wrong.
these are essentially new disks, and there just should NOT be that
many errors."

in any case i repaired them (steps 4-6).

i waited 1 day.

i did the tests again. 128 mismatches.

"wait! I just fixed them ***yesterday***!!!! Aaaaaarrrrggghhhh!!!!!"

to wit, my original questions:

what is even the normal mismatch_cnt one could, or should expect 2
drives to have in a year? 3? 10? 0?

what do i do now?  what is the repair or diagnostic procedure at this
point?  any suggestions?  what could be going wrong?  i *really* don't
think 2 almost new drives should be coming up with 128 mismatches in a
single day. so at this point, my RAID array is completely
untrustworthy, and i cannot store any important information on these
drives.

any/all help would be much appreciated.

thank you.
