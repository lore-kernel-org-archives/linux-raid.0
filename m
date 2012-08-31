From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Problems after extending partition
Date: Fri, 31 Aug 2012 11:46:52 +1000
Message-ID: <5040178C.1070900@websitemanagers.com.au>
References: <504009DF.4070408@biostat.ucsf.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <504009DF.4070408@biostat.ucsf.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Ross Boylan <ross@biostat.ucsf.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 31/08/12 10:48, Ross Boylan wrote:
> /dev/md1 was RAID 1 built from hda3 and hdb3.  After increasing the
> partition size of hd[ab]3, md1 could not be assembled.  I think I
> understand why and have a solution, but I would appreciate it if
> someone could check it.  This is with 0.90 format on Debian Lenny with
> the partitions in raid auto-detect mode.  hda and hdb are virtual
> disks inside a kvm VM; it would be time-consuming to rebuild it from
> scratch.
>
> The final wrinkle is that when I brought the VM up and dm1 was not
> constructed one of the partitions was used anyway, so they are now out
> of sync.
>
> Analysis: Growing the partitions meant that the mdadm superblocks were
> not at the expected offset from the end of the partitions, and so they
> weren't recognized as part of the array.
>
> Solution:  (step 3 is the crucial one)
> 1. Shut down the VM; call it the target VM.
> 2. Mount the disks onto a rescue VM (running squeeze) as sdb and sdc.
> 3. mdadm --create /dev/md1 --UUID=xxxxx --level=mirror
> --raid-devices=2 /dev/sdb3 missing --spare-devices=1 /dev/sdc3.
> UUID taken from the target VM.
I would think something like these two might be easier to save step 5
3. mdadm --create /dev/md1 --UUID=xxxxx --level=mirror --raid-devices=2
/dev/sdb3 missing
4. mdadm --manage /dev/md1 --add /dev/sdc3
5. wait for it to sync

Another option might have been to create the RAID1 onto the older drive
(sdc3) and then copy the content of the new drive into the array, and
then add sdb3 into this new array. This might also allow you to use a
different md version
> 4. wait for it to sync.
> 5. maybe do some kind of command to say the raid no longer has a
> spare.  It might be
> mdadm --grow /dev/md3 --spare-devices=0
> 6. Shut the rescue VM and start the target VM.
>
> Does it matter if I call the device /dev/md1 in step 3?  It is known
> as that in the target VM.
>
Hope that help,

Regards,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au

