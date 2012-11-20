From: Martijn <mailinglist@mindconnect.nl>
Subject: Re: RAID1 performance and "task X blocked for more than 120 seconds"
Date: Tue, 20 Nov 2012 10:14:39 +0100
Message-ID: <50AB49FF.90009@mindconnect.nl>
References: <50A92B52.7030905@mindconnect.nl> <50A94D9F.3060601@hardwarefreak.com> <50A958CE.5030902@mindconnect.nl> <50AA6392.2040006@hardwarefreak.com>
Reply-To: mailinglist@mindconnect.nl
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50AA6392.2040006@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: stan@hardwarefreak.com
List-Id: linux-raid.ids

Hi Stan,

On 19-11-2012 17:51, Stan Hoeppner wrote:
> On 11/18/2012 3:53 PM, Martijn wrote:
>> Thank you for your response Stan.
>> On 18-11-2012 22:05, Stan Hoeppner wrote:
>>> On 11/18/2012 12:39 PM, Martijn wrote:
>>> Your previously mentioned symptoms were leading me to this, but this one
>>> kinda seals the deal.  This sounds like classic filesystem free space
>>> fragmentation.  What filesystem is this?  The 3GB of files--are they
>>> large or small files?
>>
>> Except for /boot, it's all ext3. Free space:
>> Filesystem            Size  Used Avail Use% Mounted on
>> /dev/md127p2           60G  1.1G   56G   2% /
>> /dev/md127p6          7.9G  149M  7.4G   2% /tmp
>> /dev/md127p1          243M   19M  212M   9% /boot
>> /dev/md127p3          709G  6.5G  667G   1% /home
>> /dev/md127p5          119G  420M  112G   1% /var
>>
>> Less than 10% usage on every partition. The filesystems have always been
>> empty. This data was amongst the very first data written to the /home.
>> All partitions where created using standard Linux fdisk and then
>> formatted using mkfs.ext3.
>>
>> The 3GB consists of very mixed content: mostly small files (~1KB), and
>> just a few bigger (50MB+).
>
> Ok, so it's not a fragmentation issue.  When you copied the 3GB of files
> from one directory to another on /home you said you experienced the
> "same problem".  Could you describe that in more detail?  Also, do you
> see any lines in dmesg showing any SATA links being reset, or any
> disk/interface messages, either warnings or errors?

Thank you for taking the time to look into this. I have some news. 
Although it's not 100% clear what exactly the cause is, chances are good 
it's hardware and not software.

On your questions:
- dmesg, logs in general: no entries suggesting ANY sort of trouble with 
SATA, or any of the disks. Actually, no problems at all.
- SMART on all drives look good. (more on this later)
- Settings for devices in /sys all seem perfectly the same
- hdparm settings all seem equal for all disks
- No settings in BIOS that catch my attention. There's not that much to 
set up anyway ;-)

The copy is a (not very exciting) cp -rv /old/ /new with source and 
destination on the same partition. Immediately after it starts, the 
machine starts to feel sluggish. Very shortly after that, other programs 
you want to run start to pause for... many seconds, even minutes. This 
continues until some time after the copy is done. Meanwhile, the 
mentioned logentries appear.

Looking at the list of files coming by with -v, the copy sometimes just 
pauses for a while, on a file that isn't big. Then to continue copying 
again after some time, then pausing again, etc.

Last night I had a look together with a collegue and he suggested 
testing write performance on seperate disks to better isolate the 
problem. Make sure it's either the writing performance in general, or 
just that of software RAID.

- Read performances are good across all disks.

We tested writing performance on the spare (sdc) and that seemed ok. 
Then we put sda on fail and had the RAID rebuild itself with sdb and sdc 
as active devices.

- So, write performance on spare sdc seems good.

Then, we tested write performance on sda:

- Write performance on sda looks bad. 1/4th of that of sdc.
- Write performance on sdb also looks bad, but we've not yet been able 
to test the performance outside the RAID set, yet. The disk seems to 
'lag' behind sdc when writing.

We've put in an extra disk in (sdd) which seems to have good write 
performance when tested seperately, and plan to rebuild the RAID on sdc 
and sdd, then see what the true writing performance of sdb is.

My collegue also noted that:

- Requesting SMART regularly fails when the disk is still writing.

So summing it up, it certainly seems that this is all caused by some 
sort of hardware issue. Either with two of the disks (the formerly two 
active devices in the RAID), the cables, or the controller. And more 
importantly: probably not related to software.

- Martijn
