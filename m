From: Tim Small <tim@seoss.co.uk>
Subject: Re: Manually reconstructing a RAID5 array from a PERC3/Di (Adaptec)
Date: Wed, 12 May 2010 13:56:49 +0100
Message-ID: <4BEAA591.2090003@seoss.co.uk>
References: <4BE1F1F7.8000500@seoss.co.uk>  <4BE1F686.1070007@seoss.co.uk> <1273132047.2308.46.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1273132047.2308.46.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: "Support @ Technologist.si" <support@technologist.si>
Cc: "linux-poweredge@dell.com" <linux-poweredge@dell.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/05/10 08:47, Support @ Technologist.si wrote:
> Hi tim,
> You gave yourself a hell of a job..
> Below here are some links.. the last 2 links are linux ways to go..
>
> http://forum.synology.com/enu/viewtopic.php?f=9&t=10346
> http://www.diskinternals.com/raid-recovery/
> http://www.chiark.greenend.org.uk/~peterb/linux/raidextract/
> http://www.intelligentedu.com/how_to_recover_from_a_broken_raid5.html
>    

Ta for those who sent along some tips...

In the end, I did manage to persuade the controller to put the array 
back together (succeeded on the second attempt, after restoring the 
drive metadata from the backups I'd taken).  Part of the reason that I 
didn't try this originally is that I didn't have access to any spare 
SCSI/SCA drives, or the original RAID controller either!

Once I had access to the original block device, I created a COW snapshot 
in order to run fsck.ext3 on the filesystem without actually triggering 
any writes to the array (I think a write caused by replaying the journal 
killed the array the first time around).

Here are some handy instructions on using dmsetup to do this:

http://www.thelinuxsociety.org.uk/content/device-mapper-copy-on-write-filesystems

... which would also be handy in the case of any other file-system 
corruption, and is a lot faster than copying around image files!



Before that I tried the following method using Linux software RAID to 
reconstruct the array (which nearly worked):

. Take images of the 5 drives
. Work out how big the metadata is (assuming it's at the beginning of 
the drives):

for i in {0..1024} ; do dd if=/mnt/tmp/raid_0 skip=$i | file - ; done

... etc. for all 5 drive images.

. Create read-only loop-back devices from the drives using:

losetup -r -o 65536 /dev/loop0 /mnt/tmp/raid_0

... having found a valid MBR 64k into one of the drives - so assuming 
the Adaptec aacraid controller metadata was on the first 64k of the 
disk.  The loop device skips over this first 64k using the offset 
argument above.

. Create a set of 5 empty files (to hold the Linux md metadata) using 
dd, and set these up as loopX as well.
. Create a set of RAID appends (without metadata) using:

./mdadm --build /dev/md0 --force -l linear -n 2 /dev/loop0 /dev/loop10

etc. - with the idea that a to-be-created-later md RAID5 device will put 
their (version 0.9) metadata into the (read/write) files which make up 
the end of these RAID append arrays.  It would be handy if you could 
create software RAID5s without metadata, but you can't - they wouldn't 
be much practical use except for this soft of data-recovery purpose, I 
suppose....

. Create a set of degraded md RAID5s using commands like:

./mdadm --create  /dev/md5 -e 0.9 --assume-clean -l 5 -n 5 /dev/md0 
/dev/md1 /dev/md2 /dev/md3 missing

... for all possible permutations of 4 out-of the 5 drives, plus one 
missing (actually it tried the all-5-drives running layouts as well, but 
I disregarded these to be on the safe side).

http://www.perlmonks.org/?node_id=29374

perl permutations.pl /dev/md0 /dev/md1 /dev/md2 /dev/md3 /dev/md4 
missing | xargs -n 6 ./attempt.sh  2>&1 | tee output2.txt

Where attempt.sh look like this:

#!/bin/bash

lev=5
for layout in ls la rs ra
do  for c in 64
do echo
         echo
         echo
         echo  echo "level: $lev  alg: $layout chunk: $c  order: $1 $2 
$3 $4 $5"
         echo y | ./mdadm-3.1.2/mdadm --create  /dev/md5 -e 0.9 
--chunk=${c} -l $lev -n 5 --layout=${layout} --assume-clean $1 $2 $3 $4 
$5 > /dev/null 2>&1
         sfdisk -d /dev/md5 2>&1 | grep 'Id=82' &&  sleep 4 && fsck.ext3 
-v -n /dev/md5p1
         mdadm -S /dev/md5
done
  done


... so this assembles a v0.9 metadata md array (which puts its metadata 
at the end), and then looks for a Linux swap partition in the partition 
table, and tries a read-only fsck of the data partition.

A chunk size of 64 seemed to be the default for the BIOS but I did 
originally try others.  Anyway, this came up with two layouts which 
looked kind-of-OK (which is what I was expecting, as I assume that first 
one drive failed, then a second), both used left-asymetric parity layout.

... but e2fsck came up with loads of errors, and although the directory 
structure ended-up largely intact, the contents of most files were wrong 
- so there must be something else which is a bit different about the way 
that these aacraids layout their data - maybe something discontinuous 
about the array or something?  After I'd completed the job, I didn't 
have time to compare the linux-software-raid reconstructed image with 
the aacraid-hw-raid reconstructed version, but this would be easy enough 
todo using some test data....

I've posted this detail here in case someone is faced with having to 
attempt a similar job again, but can't get the controller to put the 
data back together - or perhaps someone who is trying this with drives 
from a different HW raid controller - in which case this method might 
Just Work (tm).

Similarly if anyone else can see anything obvious which I did wrong, 
please shout!

Cheers,

Tim.

-- 
South East Open Source Solutions Limited
Registered in England and Wales with company number 06134732.
Registered Office: 2 Powell Gardens, Redhill, Surrey, RH1 1TQ
VAT number: 900 6633 53  http://seoss.co.uk/ +44-(0)1273-808309

