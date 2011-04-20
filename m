From: David Brown <david@westcontrol.com>
Subject: Re: Direct disk access on IBM Server
Date: Wed, 20 Apr 2011 14:21:21 +0200
Message-ID: <iomj0a$e5m$1@dough.gmane.org>
References: <iok28i$tp6$1@dough.gmane.org> <4DADEBC3.9060404@hardwarefreak.com> <iomfkq$qqr$1@dough.gmane.org> <4DAEC627.3030904@grumpydevil.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DAEC627.3030904@grumpydevil.homelinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20/04/2011 13:40, Rudy Zijlstra wrote:
> On 04/20/2011 01:24 PM, David Brown wrote:
>> On 19/04/2011 22:08, Stan Hoeppner wrote:
>>> David Brown put forth on 4/19/2011 8:21 AM:
>>
>> Pros for hardware raid:
>>
>> + It can have battery backup (I don't have one at the moment - I have
>> an excellent UPS for the whole system).
>> + Rebuilds will be handled automatically by just adding new disks
>> + The card supports online resizing and reshaping
>> + It looks like the card supports caching with an SSD
>> + The card supports snapshots of the virtual drives
>
> I would add: no hassle to get boot loader installed on several disks, or
> on the raid. No limitation on which raid level used for booting
> (this is the main reason i use LSI raid cards for the system. MD raid is
> used for the big data raids)

It's true that boot loaders and software raid can be an awkward 
combination.  However, it's not /that/ hard to do once you know the 
trick.  Put a small partition on each drive that will have the 
bootloader, and tie these together with a multi-drive raid1 set with 
metadata format 0.90 (which has the metadata at the end, rather than the 
beginning).  Use that for a /boot partition.  Once you've got your base 
system setup, and grub installed on the first disk, you can manually 
install the grub first stage loader to the MBR of each of the disks. 
You only need to do this once at the first installation (unless you have 
grub updates that change the first stage bootloader).

When booting, as far as grub is concerned the /boot partition is a 
normal partition.  It doesn't matter that it is part of a raid1 array - 
grub sees a normal partition and reads its various configuration files 
and proceeds with the boot.  Once you've actually booted, the partition 
is mounted as read-write raid1, and any updates (new kernels, etc.) are 
written to all disks.

Yes, it's a few extra steps.  But they are not too hard, and there are 
plenty of hits with google showing the details.  And if you are using 
LVM, you are probably already used to the idea of having a separate 
/boot partition.  I have done this successfully with a three-disk 
machine - it would happily boot from any of the disks.


>>
>> Cons for hardware raid:
>>
>> - The disks are tied to the controller, so if the machine or its
>> controller fails, the data may not be recoverable (that's what
>> external backups are for!).
> I have been using LSI for many years.
> = The critical point is the controller, not the machine. I've moved
> controller & disks between machines several times and no problems
> = if the controller fails, you can replace with same or later
> generation. It will recognize the disks and give you full access to your
> data. I've done this twice. Once from U160 to later U320 raid, once
> replacement with same generation card. The replacement of U160 to U320
> was not because of controller failure, i was upgrading the system.
>

Okay, that's good to know.  LSI raid controllers are not hard to get, so 
I am not afraid of being able to find a replacement.  What I was worried 
about is how much setup information is stored on the disks, and how much 
is stored in the card itself.  If a replacement controller can identify 
the disks automatically and restore the array, then that's one less 
thing to worry about.

>> - If a drive is used for a particular raid level, it is /all/ used at
>> that level. Thus no mixing of raid10 and raid5 on the same disk.
>> - It needs the MegaCli or other non-standard software for
>> administration at run-time.
>> - Testing and experimentation is limited, because you can't fake an
>> error (other than drive removal) and you can't fake drive size changes.
>>
>>
>> Pros for software raid:
>>
>> + It's flexible (such as raid1 for /boot, raid10 for swap, and raid5
>> for data - all within the same set of disks).
>> + It uses standard software (any live CD or USB will work, as will any
>> distribution).
>> + You can put the disks in any Linux machine to recover the data if
>> the main machine dies.
>> + You can use standard disk administration software (smartctl,
>> hddtemp, hdparm, etc.)
>> + You can build layered raids, such as with one-disk mirrors at the
>> bottom and top, for extra safety during risky operations. You can also
>> use external drives for such operations - they are slower, but easy to
>> add for temporary changes.
>> + You have more choices for raid levels (raid10,far is particularly
>> useful, and you can have raid6 without an extra license key).
>>
>>
>> Cons for software raid:
>>
>> - Adding replacement disks involves a few more changes, such as
>> partitioning the disks and adding the right partitions to the right
>> arrays.
>>
> With respect to layered RAID:
> - several raid cards support RAID10.
> - you can do MD raid in top of HW raid
>

Yes, the raid card I have can do RAID10.  But it can't do Linux md style 
raid10,far - I haven't heard of hardware raid cards that support this. 
For most uses, raid10,far is significantly faster than standard raid10 
(though as yet mdadm doesn't support reshaping and resizing on raid10,far).

It is certainly possible to do MD raid on top of HW raid.  As an 
example, it would be possible to put a raid1 mirror on top of a hardware 
raid, and mirror it with a big external drive for extra safety during 
risky operations (such as drive rebuilds on the main array).  And if I 
had lots of disks and wanted more redundancy, then it would be possible 
to use the hardware raid to make a set of raid1 pairs, and use md raid5 
on top of them (I don't have enough disks for that).

It is not possible to put an MD raid /under/ the HW raid.  I started 
another thread recently ("Growing layered raids") with an example of 
putting a raid 5 on top of a set of single-disk raid1 "mirrors" to allow 
for safer expansion.

Whether it is worth the effort doing something like this is another 
question, of course :-)

