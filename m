From: Christopher White <linux@pulseforce.com>
Subject: Re: mdadm does not create partition devices whatsoever, "partitionable"
 functionality broken
Date: Fri, 13 May 2011 20:04:31 +0200
Message-ID: <4DCD72AF.1070809@pulseforce.com>
References: <4DCD4A83.8060202@pulseforce.com>	<4DCD6119.3080705@turmel.org>	<4DCD67EF.1070602@pulseforce.com>	<4DCD6B27.70402@pulseforce.com> <20110513234055.4307c536@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110513234055.4307c536@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>, Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 5/13/11 7:40 PM, Roman Mamedov wrote:
> On Fri, 13 May 2011 19:32:23 +0200
> Christopher White<linux@pulseforce.com>  wrote:
>
>> I forgot to mention that I've also tried "sudo fdisk /dev/md1" and
>> creating two partitions that way. It fails too.
>>
>> This leads me to conclude that /dev/md1 was never created in
>> partitionable mode and that the kernel refuses to create anything beyond
>> a single partition on it.
> Did you try running "blockdev --rereadpt /dev/md1"?
>
Hmm. Hmmmm. One more for good measure: Hmmmmmmm.

That's weird! Here's the thing: Fdisk is *just* for creating the 
partitions, not formatting them, so for that one it makes sense that you 
must re-read the partition table before you have a partition device to 
execute "mkfs.XXX" on.

However, Gparted on the other hand is BOTH for creating partition tables 
AND for executing the "make filesystem" commands (formatting). 
Therefore, Gparted is supposed to tell the kernel about partition table 
changes BEFORE trying to access the partitions it just created. 
Basically, Gparted goes: Blank disk, create partition table, create 
partitions, notify OS to re-scan the table, THEN access the new 
partition devices and format them. But instead, it skips the "notify OS" 
part when working with md-arrays!

When you use Gparted on PHYSICAL hard disks, it properly creates the 
partition table and the OS is updated to immediately see the new 
partition devices, to allow them to be formatted.

Therefore, what this has shown is that the necessary procedure in 
Gparted is:
* sudo gparted /dev/md1
* Create the partition table (gpt for instance)
* Create as many partitions as you need BUT SET THEIR TYPE TO 
"unformatted" (extremely important).
* Go back to a terminal and execute "sudo blockdev --rereadpt /dev/md1" 
to let the kernel see the new partition devices
* Now go back to the Gparted and format the partitions, or just do it 
the CLI way with mkfs.ext4 manually. Either way, it will now work.

So how should we sum up this problem? Well, that depends. What is 
responsible for auto-discovering the new partitions when you use Gparted 
on a PHYSICAL disk (which works perfectly without manual re-scan 
commands)? 1) Is it Gparted telling the kernel to re-scan, or 2) is it 
the kernel that auto-watches physical disks for changes?

If 1), it means Gparted needs a bug fix to tell the kernel to re-scan 
the partition table for md-arrays when you re-partition them.
If 2), it means the kernel doesn't watch md-arrays for partition table 
changes, which debatably it should be doing.


Thoughts?
