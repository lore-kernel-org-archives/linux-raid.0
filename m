From: Corey Hickey <bugfood-ml@fatooh.org>
Subject: Re: RAID5, 2 out of 4 disks failed, Events value differs too much
Date: Thu, 07 Dec 2006 16:34:00 -0800
Message-ID: <4578B2F8.4060200@fatooh.org>
References: <20061205084802.16720@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20061205084802.16720@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bodo Thiesen wrote:
> Hi, I have a little problem:
> 
> Some hours ago the second of four disks were kicked out of my RAID5 thus rendering it unusable. As of my current knowledge, the disks are still working correctly (I assume a cable connection problem) but that's not the problem. The real problem is, that the first failed disk has an event value of 9102893, the second failed disk has a value of 9324862 and the other two disks have a value of 9324869. In this case, what is the best to do to recover the RAID? Because just recreating the array with the 9324862-disk and the two 9324869-disks and later hotadding the 9102893-disk, is just unclean and as I understood it, this would trigger some silent data failures. Is there a chance to prevent this data failures to happen at all, or is it at least possible to tell, where this error(s) are (so I can manually check the data and take appropriate steps)? Remember that I still have the data from th
 e first failed disk, from which parts may still be relatively up to date.
> 
> Has anyone had this problem already and found a nice solution for this?

If nobody gives you any better advice, I would follow this approach. 
These commands are examples and may need to be fixed; I haven't had this 
exact problem before (only similar ones) and I can't test anything right 
now.

First, force the reassembly of the array using the three freshest disks.
# mdadm --assemble --force --run /dev/md0 /dev/sdb /dev/sdc /dev/sdd

Next, use whatever fsck program corresponds to your filesystem and do a 
read-only check. Something like:
# reiserfsck --check /dev/md0

If fsck finds only a few problems, then it's probably safe to go ahead 
and tell fsck to fix them; data loss will be minimal or nonexistent.
# reiserfsck --fix-fixable /dev/md0

Now you ought to be able to mount the filesystem and look around.
# mount /dev/md0

If all looks good, then hot-add the stale disk and let it resync.
# mdadm /dev/md0 -a /dev/sda

Good luck,
Corey
