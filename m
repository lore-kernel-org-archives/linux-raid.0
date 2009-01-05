From: Neil Brown <neilb@suse.de>
Subject: Re: Need urgent help in fixing raid5 array
Date: Tue, 6 Jan 2009 09:11:01 +1100
Message-ID: <18786.34165.639790.37753@notabene.brown>
References: <451872.61166.qm@web30802.mail.mud.yahoo.com>
	<alpine.DEB.1.10.0901011039110.9903@p34.internal.lan>
	<467705.96388.qm@web30807.mail.mud.yahoo.com>
	<alpine.DEB.1.10.0901011328380.17888@p34.internal.lan>
	<344038.60917.qm@web30808.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Myers on Thursday January 1
Sender: linux-raid-owner@vger.kernel.org
To: Mike Myers <mikesm559@yahoo.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org, john lists <john4lists@gmail.com>
List-Id: linux-raid.ids

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
