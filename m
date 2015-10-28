From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Converting 4 disk RAID10 to RAID5
Date: Wed, 28 Oct 2015 12:57:41 +1100
Message-ID: <56302B95.3000006@websitemanagers.com.au>
References: <562D8142.80507@websitemanagers.com.au>
 <562E345D.5030206@turmel.org> <562EBD58.2040306@websitemanagers.com.au>
 <562F1789.9080000@gmail.com> <562F1A61.6010709@websitemanagers.com.au>
 <562F6A77.20502@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <562F6A77.20502@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Anugraha Sinha <asinha.mailinglist@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 27/10/15 23:13, Phil Turmel wrote:
> On 10/27/2015 02:32 AM, Adam Goryachev wrote:
>> On 27/10/15 17:19, Anugraha Sinha wrote:
> \
>>> This will restart your array with the required raid-level and also
>>> start the resyncing process.
> You shouldn't have needed to stop it.
>
>> I got:
>> mdadm: Failed to restore critical section for reshape, sorry.
>> Possibly you needed to specify the --backup-file
> Probably just need "mdadm /dev/md0 --grow --continue --backup-file=...."
>
> where .... is a file location outside the array.  You may also need
> --invalid-backup
>
> Phil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thank you, that did it (if I don't do the stop):
mdadm --grow --continue --backup-file=/tmp/nofile /dev/md0
mdadm: Need to backup 3072K of critical section..
mdadm: Reshape is delayed, but cannot wait carefully with this kernel.
        You might experience problems until other reshapes complete.

Just in case someone else is looking later, this is how to convert from 
4 disk RAID10 to 4 disk RAID5.

Starting again from scratch, I followed this process:
mdadm --create --level=10 --raid-devices=4 /dev/md0 /dev/vd[cdef]1
mdadm --grow --bitmap=internal /dev/md0

#This gets me to my current live config....

# Remove the bitmap since it causes problems later
mdadm --grow --bitmap=none /dev/md0

# Grow to RAID0 which basically just drops two devices, it finishes 
immediately.
mdadm --grow --level=0 --raid-devices=2 /dev/md0

# Grow to RAID5, only add one device
mdadm --grow --level=5 --raid-devices=3 /dev/md0 -a /dev/vdd1

# A resync is completed, looks good/normal

# Grow to add the 4th device
mdadm --grow --raid-devices=4 /dev/md0 -a /dev/vdf1

# Problems, stuck with resync=DELAYED, we were not asked to supply a 
backup file for this...
# Just ask mdadm to continue, and now supply a backup file
mdadm --grow --continue --backup-file=/tmp/nofile /dev/md0

# All good. Add the bitmap again
mdadm --grow /dev/md0 --bitmap=internal

It would seem to me that this is generally a relatively "dangerous" 
exercise, you are very vulnerable to failed disks due to using RAID0, 
and then migrating to RAID5, any read/write failure during that process 
could cause significant data loss. Finally, the grow to add the 4th disk 
should be fine, unless you have a problem with the same block on two 
devices.

Any final comments/suggestions before I start the process "for real"?

Thanks,
Adam


-- 
Adam Goryachev Website Managers www.websitemanagers.com.au


