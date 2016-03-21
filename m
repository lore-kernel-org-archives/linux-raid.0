From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: problems with dm-raid 6
Date: Tue, 22 Mar 2016 09:54:54 +1100
Message-ID: <56F07BBE.1010306@websitemanagers.com.au>
References: <trinity-226526b2-6058-40bf-a276-9c1b47a80b3b-1458600120646@3capp-gmx-bs35>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <trinity-226526b2-6058-40bf-a276-9c1b47a80b3b-1458600120646@3capp-gmx-bs35>
Sender: linux-raid-owner@vger.kernel.org
To: Patrick Tschackert <Killing-Time@gmx.de>, lists@colorremedies.com, Andreas.Klauer@metamorpher.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22/03/16 09:42, Patrick Tschackert wrote:
> Hi Chris,
>
>>  From what I understand, no, the smartctl are after the scrub check.
> That's correct, I ran those shortly before sending the OP.
>
>> But it's an open question how long after device failure he
>> actually noticed it before doing the rebuild and how he did that
>> rebuild;
> I noticed something was wrong directy after the reboot. I opened the LUKS container (which worked) and tried to mount the btrfs filesys, which didn't. After noticing the raid was in the state "clean, degraded", I triggered the restore by running mdadm --run, because i already had two hotspares present in the raid. So one of the hotspares was used to do the restore.
> After that, i ran mdadm --readwrite /dev/md0, because the raid was set to read only. The problem with mounting the btrfs filesys still occurred.
>
>> But at this point we need to hear back from Patrick.
> Sorry for taking so long, long day at work :(
>
>> You should not assemble the original RAID anymore anyhow, anything
>> you write to the array at this point will likely only increase
>> damages. The overlay allows you to experiment in read-"write"
>> mode without actually changing anything on your disks.
>> Agreed. If it turns out there are some repairs needed within Btrfs
>> it's better with the overlay because it's unclear based on the errors
>> thus far what repair step to use next, and some of these repair
>> attempts can still sometimes make things worse (which are of course
>> bugs, but nevertheless...)
> I'll look into overlays and try that tomorrow, it's too late and i don't want to further screw this up by doing this half asleep :/
> Based on your advice, I'll use an overlay on the array and then try to fix the btrfs filesystem. If I understand correctly, the dm overlay file would enable me to revert to the current state, in case the btrfs repair goes wrong?
>
> Regards,
> Patrick

I think the suggestion is to use overlays on each individual 
drive/partition that is used in the RAID array, and then try/test adding 
a subset of those drives to assemble the raid array. That way, any 
writes to the raid will not damage the underlying data. To my untrained 
eye, it looks like maybe the "first" drive in your array is correct, and 
hence the first block returns the correct data so you can access the 
LUKS, but the second (or third, or fourth) is damaged, and thats why you 
can't read the filesystem inside the LUKS. Hence, try swapping the order 
of the disks and/or leaving different disks out, and see if you can then 
read both LUKS and the filesystem inside it.

Once you can do that, then either the filesystem will "Just Work" or 
else you might need to do a repair depending on what exactly went wrong, 
and how much was written during that time.

Regards,
Adam


-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
