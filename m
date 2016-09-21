From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Enlarging device of linear array again (Thank you Stan!)
Date: Wed, 21 Sep 2016 10:01:41 +1000
Message-ID: <9b6dbd02-cdf6-2417-3dd9-5496c67075b7@websitemanagers.com.au>
References: <20160920213442.1559310f@hoferr-X240.hofer.rummelring>
 <57E1AF80.8000406@youngman.org.uk>
 <20160921010626.31ced172@hoferr-X240.hofer.rummelring>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160921010626.31ced172@hoferr-X240.hofer.rummelring>
Sender: linux-raid-owner@vger.kernel.org
To: Ramon Hofer <ramonhofer@bluewin.ch>, Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21/09/16 09:06, Ramon Hofer wrote:
> Thank you very much for your answer, Wol!
>
>
> On Tue, 20 Sep 2016 22:52:00 +0100
> Wols Lists <antlists@youngman.org.uk> wrote:
>
>> On 20/09/16 20:34, Ramon Hofer wrote:
>>> I am using 4 TB WD red to replace the 1.5 TB disks.
>>>
>>> Do you think this could work?
>>> Are there any pitfalls?
>>> Should I unmount the array to perform all these steps? It might be
>>> safer since there is no redundancy during the replacement?
>>>
>>> I just wanted to check first before making any mistakes. Instead of
>>> maybe afterwards asking for help recovering my data :-P
>> I don't quite understand what you are doing, but ...
> Sorry I forgot to mention some things.
>
> I have a linear md0 containing four raid5 (md[1234]) to which XFS is
> stripe aligned due to the performance. [1], [2]
>
> The case for my home media server is a Norco [3] with 20 slots. Four are
> dedicated to MythTV.
> 4 x 4 are in md0.
>
> I want to replace the four 1.5 TB disks with 4 TB to have more
> space.
>
> On the four 4 TB disks I create two partitions (1.5 TB and 2.5 TB).
> Each old 1.5 TB disk gets replaced with the partition on the 4 TB
> disks. From the 2.5 TB of each of the four 4TB disks I create a new
> RAID5 (md5) and add this to the linear md0. At the end I expand the
> file system.
Assuming that you are replacing the four disks that are in the RAID5 
array which is at the "end" of your linear raid0, then you don't 
actually need to create two partitions at all. Just replace the four 
drives (dd from source to destination while offline). When complete, (if 
they are partitioned, delete/re-create the single partition to fill the 
drive), grow the RAID5 array to fill the new drives, then grow the md0 
to take the rest of the RAID5 space onto the end of the drive, then grow 
your filesystem/etc.

>> The other way to do it is just shut the machine down, remove all
>> drives except one and put a new big drive in. Boot from a rescue CD,
>> partition the new drive and dd the old partitions to the new drive.
>> Again rinse and repeat for all four drives, and then put all four new
>> drives in the system and reboot. At which point you can expand all the
>> filesystems/raids to use all the space available. This *shouldn't* be
>> a risky operation. Indeed, if you're going to shut the array down,
>> this is probably the simplest and safest option.
> So you suggest to dd the 1.5 TB disks to the 1.5 TB
> partition on the 4 TB disks instead of just let mdadm rebuild the
> array?
Agreed, possibly faster, definitely safer if you value your data.
> Can I just do:
>
> sudo dd if=/dev/sde of=/dev/sdf1
Depends, is the existing sde partitioned? Make extra sure you pair up 
each source/destination drive, etc...
>
> Assuming sde is the old 1.5 TB disk and sdf1 is the 1.5 TB partition on
> the new 4 TB disk.
> Can I be sure that mdadm recognizes the partitions correctly as the
> replacement for the old disks?
mdadm will use the content of the drive/partition to work out what 
belongs in/to what array, so it should be fine. However, its a great 
idea to keep the four old drives aside until you are sure everything is 
working properly (another advantage to avoid replacing one at a time...)

Note that this advice might mess with your "performance tuning", I don't 
know enough about that side of things to comment further.

Regards,
Adam



-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
