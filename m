From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID performance -  5x SSD RAID5 - effects of stripe cache sizing
Date: Thu, 07 Mar 2013 22:02:10 -0600
Message-ID: <513962C2.5020809@hardwarefreak.com>
References: <51134E43.7090508@websitemanagers.com.au> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au> <5120A84E.4020702@websitemanagers.com.au> <51222A81.9080600@hardwarefreak.com> <51250377.509@websitemanagers.com.au> <5125B8E5.5000502@hardwarefreak.com> <5125C154.3090603@websitemanagers.com.au> <51272808.7070302@hardwarefreak.com> <512A79D3.9020502@hardwarefreak.com> <5130D206.4090302@websitemanagers.com.au> <5131C338.8010402@hardwarefreak.com> <c886b8ac-9786-4e7d-b6f1-b6fb5d801c85@email.android.com> <5134917F.8060903@hardwarefreak.com> <5134CB39.8050000@websitemanagers.com.au>
  <5135BB2C.5030400@hardwarefreak.com> <513614F9.1050808@websitemanagers.com.au> <51384366.2030307@hardwarefreak.com> <51392E1F.3080000@websitemanagers.com.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51392E1F.3080000@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 3/7/2013 6:17 PM, Adam Goryachev wrote:
> On 07/03/13 18:36, Stan Hoeppner wrote:

>> Run FIO on the DC itself and see what your NTFS throughput is to this
>> 300GB filesystem.  Use a small file, say 2GB, since the FS is nearly
>> full.  Post results.
> 
> Can't, I don't see a version of fio that runs on win2000...

Well find another utility, or just do a file copy with a stop watch.
The point here is to determine if NTFS is part of the bottleneck, as you
already verified, IIRC, that FIO at the hypervisor level is doing ~100MB/s.

> I had somewhat forgotten about FTP, and it does provide nice simple
> performance results/numbers too. I'll give this a try, talking to
> another linux box on the network, it should achieve 100MB/s (gigabit
> speeds) or close to it. I'll also run the same FTP test from one of the
> 2003 boxes for comparison.

I think you missed the point.  SMB with TS<->DC is ~10MB/s, but should
be more like 100MB/s.  Run the FTP client on TS against the FTP service
on the DC.  Get and put files from/to the 300GB NTFS volume that is
shared.  If FTP is significantly faster then we know SMB is the problem,
or something related to SMB, not TCP.

> Well, during the day, under normal user load, the CPU frequently rises
> to around 70 to 80%, while this is not as clear cut as 100%, it makes me
> worry that it is limiting performance.

Agreed.  CPU burn shouldn't be that high for SMB serving.  The cause
could be any number of things, or a combination of things.  The steps
I'm suggesting will allow us to identify the cause of the burn and the
low SMB throughput.

> NTFS compression is already disabled on all volumes.... I've *never*
> enabled it on any system I've ever been responsible for, and never seen
> anyone else do that. However, due to the age of this system, it is
> possible that it has been enabled and then disabled again at some point.

Ok, good.  No compression.  How about NTFS encryption?

> I only bumped it up a small amount just in case I got burned by windows
> 2000 having an upper limit on disk size supported. I couldn't find a
> clear answer on the maximum size supported.... I'll probably increase it
> to at least 400 or even 500 as soon as I complete the upgrade to win2003.

2TB is the minimum ceiling.  If it's a Dynamic Disk the limit is 16TB:
http://technet.microsoft.com/en-us/library/cc779002%28v=ws.10%29.aspx

>> Growing filesystem in small chunks like this is a recipe for disaster.
>>  Your free space map is always heavily fragmented and is very large.
>> The more entries the filesystem driver must walk the more CPU you burn.
>>  Recall we just discussed the table walking overhead of the md/RAID
>> stripe cache?  Filesystem maps/tables/B+ trees are much, much larger
>> structures.  When they don't fit it cache we read memory, and when they
>> don't fit in memory (remember you "pool" problem) we must read from disk.
> 
> Yes, I did try and run a defrag (win2000 version) on the volume. I was

*NEVER* run a defragger against a filesystem residing on SSDs.  It will
shorten the life of the flash cells due to wear leveling, and thus the
SSDs themselves:  http://www.intel.com/support/ssdc/hpssd/sb/CS-029623.htm#5

And it will not fix the problem I was describing.

>> If you've been expanding this NTFS this way for a while it would also
>> explain some of your CPU burn at the DC.  FYI, XFS is a MUCH higher
>> performance and much more efficient filesystem than NTFS ever dreamed of
>> becoming, but even XFS suffers slow IO and CPU burn due to heavily
>> fragmented free space.
> 
> Nope, it has had the same 300G HDD (279G) for at least 6 years (as far
> as I know). I'm pretty sure is has only been extended by physical
> replacement of the HDD from time to time.

Ok. Good.  We're narrowing things down a bit.

> The current plan is to upgrade to win2003, I'm hoping this will improve
> performance equivalent to what is being achieved on the other 2003
> servers, which should make the users happy again. I may increase the
> disk space and have another crack at defrag prior to the upgrade since
> the upgrade won't happen until next weekend at the earliest.

Do NOT defrag.  This should be well driven home at this point.

When you upgrade to 2003, make sure you use the open source Xen
paravirtualized SCSI and NIC drivers:

http://jolokianetworks.com/70Knowledge/Virtualization/Open_Source_Windows_Paravirtualization_Drivers_for_Xen

-- 
Stan


