From: Mike Myers <mikesm559@yahoo.com>
Subject: Re: Need urgent help in fixing raid5 array
Date: Mon, 5 Jan 2009 14:22:47 -0800 (PST)
Message-ID: <546794.45786.qm@web30802.mail.mud.yahoo.com>
References: <451872.61166.qm@web30802.mail.mud.yahoo.com> <alpine.DEB.1.10.0901011039110.9903@p34.internal.lan> <467705.96388.qm@web30807.mail.mud.yahoo.com> <alpine.DEB.1.10.0901011328380.17888@p34.internal.lan> <344038.60917.qm@web30808.mail.mud.yahoo.com> <18786.34165.639790.37753@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org, john lists <john4lists@gmail.com>
List-Id: linux-raid.ids

Thanks!  I see what you are doing here.  So since none of these commands actually change the underlying data, if I get the order right. the array will come up and the LVM superblock will be visible, and then I can try and bring the filesystem online?  If I get the order wrong, I can just try it again with another combination.  Do I have that right?  

I should probably print out all the existing metadata and save it since the data will be wiped out by the create.

How could the drives get the bad metadata on them>  I've played with software raid for about 4 years and have seen seen something this strange.

thx
mike




----- Original Message ----
From: Neil Brown <neilb@suse.de>
To: Mike Myers <mikesm559@yahoo.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>; linux-raid@vger.kernel.org; john lists <john4lists@gmail.com>
Sent: Monday, January 5, 2009 2:11:01 PM
Subject: Re: Need urgent help in fixing raid5 array

On Thursday January 1, mikesm559@yahoo.com wrote:
> 
> (md1 is comprised of sdd1 sdf1 sdg1 sdh1 sdj1 sdk1 sdo1) 
> 
> (none):~> mdadm --examine /dev/sdd1 /dev/sdf1 /dev/sdg1 /dev/sdh1
....
> (none):~> mdadm --examine /dev/sdj1 /dev/sdk1 /dev/sdo1
....

So, of these 7 devices, 5 of them (d1 f1 h1 j1 k1) think that are
good members of the array with current metadata, and the other two (g1
and o1) have old/wrong metadata.

This means that you need to recreate the array.

The questions:  Which of g1 and o1 has more recent valid data, and
which should be device '1' and which should be device '2'.
Depending on the answer to these two questions, the command to you
will be one for the following 4 possibilities.

mdadm -C /dev/md1 -e1.0 -l5 -n7 -c128 -b internal /dev/sdh1 /dev/sdg1 missing /dev/sdk1 /dev/sdf1 /dev/sdd1 /dev/sdj1
mdadm -C /dev/md1 -e1.0 -l5 -n7 -c128 -b internal /dev/sdh1 /dev/sdo1 missing /dev/sdk1 /dev/sdf1 /dev/sdd1 /dev/sdj1
mdadm -C /dev/md1 -e1.0 -l5 -n7 -c128 -b internal /dev/sdh1 missing /dev/sdg1 /dev/sdk1 /dev/sdf1 /dev/sdd1 /dev/sdj1
mdadm -C /dev/md1 -e1.0 -l5 -n7 -c128 -b internal /dev/sdh1 missing /dev/sdo1 /dev/sdk1 /dev/sdf1 /dev/sdd1 /dev/sdj1

These commands will not change the data on the device, just the
metadata.
Once you have created the array, you try to validate the data (fsck or
similar).
If it looks bad, stop the array and try a different command.


Note: the metadata on g1 and o1 is very strange.  It looks like an old
copy of the metadata from sdh1.  so it could be that one of g1 or o1
is really the first drive in the array, and h1 one of the two
'missing' devices.  So if none of the 4 commands I gave work, try
other permutations with o1 or g1 first, and h1 second or third.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



      
