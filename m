From: Sam Bingner <sam@bingner.com>
Subject: Re: Failed during rebuild (raid5)
Date: Mon, 6 May 2013 01:10:56 +0000
Message-ID: <B121AE98-2918-4C9F-9138-F79E9348BFFB@bingner.com>
References: <51839E4F.7050102@midgaard.us>
 <CANU9nTneT2CRWJhdN=d87Hb7W9M+apQH+fRE-S+sieZ-W6+hjg@mail.gmail.com>
 <51866602.8000704@midgaard.us>,<518693EF.6090802@midgaard.us>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <518693EF.6090802@midgaard.us>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Boman <aboman@midgaard.us>
Cc: Ole Tange <tange@binf.ku.dk>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On May 5, 2013, at 7:17 AM, "Andreas Boman" <aboman@midgaard.us> wrote:

> On 05/05/2013 10:00 AM, Andreas Boman wrote:
>> On 05/03/2013 08:26 AM, Ole Tange wrote:
>>> On Fri, May 3, 2013 at 1:23 PM, Andreas Boman<aboman@midgaard.us>  wrote:
>>> 
>>>> This morning I came up to see the array degraded with two missing drives,
>>>> another failed during the rebuild.
>>> I just started this page for dealing with situations like yours:
>>> https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID
>>> 
>>> 
>>> /Ole
>> 
>> After having ddrescue running all night, it dropped to copying at a rate of 512B/s. I interrupted it and restarted, it stays at that speed. shows no errors:
>> 
>>   Press Ctrl-C to interrupt
>>          Initial status (read from logfile)
>>    rescued:   557052 MB,  errsize:       0 B,  errors:       0
>>    Current status
>>    rescued:     1493 GB,  errsize:       0 B,  current rate:      512 B/s
>>       ipos:   937316 MB,   errors:       0,    average rate:   16431 kB/s
>>          opos:   937316 MB,     time from last successful read:       0 s
>>          Copying non-tried blocks...
>> 
>> 
>> However that is much too slow...
>> 
>> Then, I decided to take a look at the superblocks and to my horror discovered this:
>> 
>> # mdadm --examine /dev/sd[b-g] >>raid.status
>> mdadm: No md superblock detected on /dev/sdb.
>> mdadm: No md superblock detected on /dev/sdc.
>> mdadm: No md superblock detected on /dev/sdd.
>> mdadm: No md superblock detected on /dev/sde.
>> mdadm: No md superblock detected on /dev/sdf.
>> mdadm: No md superblock detected on /dev/sdg.
>> 
>> Can I recover still? What is going on here?
>> 
>> Thanks,
>> Andreas
> Turns out the superblocks are there. I ran --examine on the disk instead of partition. OOps.
> 
> I still have the problem with ddrescue being very slow, it is running at 512 B/s pretty much no matter what options I use. The ddrescued disk does NOT have a md superblock. I tried to ddrescue -i to skip and grab the last 3MB or so of the disk, that seemed to work, but I still don't have the superblock.
> 
> How do I find/recover the superblock from the original disk?
> 
> After that is done I'll try to get the array up with 4 disks, then add the spare and have it rebuild. After that I'll add a disk to go to raid 6.
> 
> Thanks,
> Andreas
> 
You need to just let ddrescue run - it is probably on the area of the disk with problems.  When it gets past that it should speed up again.

If you just want to get the rest first you could add an entry to the log file saying some area around where you are now failed so that it goes back and tries it later, but I would not do that if I were you.

Sam