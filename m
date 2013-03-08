From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance -  5x SSD RAID5 - effects of stripe cache sizing
Date: Fri, 08 Mar 2013 11:17:35 +1100
Message-ID: <51392E1F.3080000@websitemanagers.com.au>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au> <5120A84E.4020702@websitemanagers.com.au> <51222A81.9080600@hardwarefreak.com> <51250377.509@websitemanagers.com.au> <5125B8E5.5000502@hardwarefreak.com> <5125C154.3090603@websitemanagers.com.au> <51272808.7070302@hardwarefreak.com> <512A79D3.9020502@hardwarefreak.com> <5130D206.4090302@websitemanagers.com.au> <5131C338.8010402@hardwarefreak.com> <c886b8ac-9786-4e7d-b6f1-b6fb5d801c85@email.android.com> <5134917F
 .8060903@hardwarefreak.com> <5134CB39.8050000@websitemanagers.com.au> <5135BB2C.5030400@hardwarefreak.com> <513614F9.1050808@websitemanagers.com.au> <51384366.2030307@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51384366.2030307@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/03/13 18:36, Stan Hoeppner wrote:
> On 3/5/2013 9:53 AM, Adam Goryachev wrote:
>> On 05/03/13 20:30, Stan Hoeppner wrote:
>> Thanks to the tip about running fio on windows, I think I've now come
>> full circle.... Today I had numerous complaints from users that their
>> outlook froze/etc, and some cases were the TS couldn't copy a file from
>> the DC to it's local C: (iSCSI). The cause was the DC was logging events
>> with event ID 2020 which is "The server was unable to allocate from the
>> system paged pool because the pool was empty". Supposedly the solution
>> to this is tuning two random numbers in the registry, not much is said
>> what the consequences of this are, nor about how to calculate the
>> correct value. 
> ...
>> Running the same fio test on the same TS (win2003) against a SMB share
>> from the DC (SMB -> Win2000 -> Xen -> iSCSI -> etc)
>>> READ: io=16384MB, aggrb=14818KB/s, minb=14818KB/s, maxb=14818KB/s, mint=1132181msec, maxt=0msec
>>> WRITE: io=16384MB, aggrb=8039KB/s, minb=8039KB/s, maxb=8039KB/s, mint=2086815msec, maxt=0msec
> 
> Run FIO on the DC itself and see what your NTFS throughput is to this
> 300GB filesystem.  Use a small file, say 2GB, since the FS is nearly
> full.  Post results.

Can't, I don't see a version of fio that runs on win2000...

> Fire up the Windows CLI FTP client in a TS session DOS box and do a GET
> and PUT into this filesystem share on the DC.  This will tell us if the
> TS to DC problem is TCP in general or limited to SMB.  Post transfer
> rate results for GET and PUT.

I had somewhat forgotten about FTP, and it does provide nice simple
performance results/numbers too. I'll give this a try, talking to
another linux box on the network, it should achieve 100MB/s (gigabit
speeds) or close to it. I'll also run the same FTP test from one of the
2003 boxes for comparison.

>> This is pretty shockingly slow, and seems to clearly indicate why the
>> users are so upset... 14MB/s read and 8MB/s write, it's a wonder they
>> haven't formed a mob and lynched me yet!
> 
> I've never used FIO on Windows against a Windows SMB share.  And
> according to Google nobody else does.  So before we assume these numbers
> paint an accurate picture of your DC SMB performance, and that the CPU
> burn isn't due to an anomaly of FIO, you should run some simple Windows
> file copy tests in Explorer and use Netmeter to measure the speed.  If
> they're in the same ballpark then you know you can somewhat trust FIO
> for SMB testing.  If they're wildly apart, probably not.

Well, during the day, under normal user load, the CPU frequently rises
to around 70 to 80%, while this is not as clear cut as 100%, it makes me
worry that it is limiting performance.

>> However, the truly useful information is that during the read portion of
>> the test, the DC has a CPU load of 100% (no variation, just pegged at
>> 100%), during the write portion, it fluctuates between 80% to 100%.
> 
> That 100% CPU is bothersome.  Turn off NTFS compression on any/all NTFS
> volumes residing on SAN LUNs on the SSD array.  You're burning 100% DC
> CPU at ~12MB/s data rate on the DC, so I can only assume it's turned on
> for this 300GB volume.  These SSDs do on the fly compression, and very
> quickly as you've seen.  Doing NTFS compression on top simply wastes cycles.

NTFS compression is already disabled on all volumes.... I've *never*
enabled it on any system I've ever been responsible for, and never seen
anyone else do that. However, due to the age of this system, it is
possible that it has been enabled and then disabled again at some point.

> This should drop the CPU burn for new writes to the filesystem.  It
> probably won't for reads, since NTFS must still decompress the existing
> 250GB+ of files.  If CPU drops considerably for writes but reads still
> eat 100%, the only fix for this is to backup the filesystem, reformat
> the device, then restore.  

Since it was already disabled, I would expect that the majority of files
currently in use (especially the problematic outlook pst files) have
already been modified/decompressed anyway.

> On the off chance that NTFS compression is
> more efficient than the SandForce controller, you probably want to
> increase the size of the volume before formatting.  And in fact,
> Sysadmin 101 tells us never to run a production filesystem at more than
> ~70% capacity, so it would be smart to bump it up to 400GB to cover your
> bases.

I only bumped it up a small amount just in case I got burned by windows
2000 having an upper limit on disk size supported. I couldn't find a
clear answer on the maximum size supported.... I'll probably increase it
to at least 400 or even 500 as soon as I complete the upgrade to win2003.

> My second recommendation is to turn off the indexing service for all
> these NTFS volumes as well as this will conserve CPU cycle as well.

That is a good thought... I recently did do a complete file search on
the volume, and it seemed to need to traverse the directory tree anyway
(I was looking for files *.bak to delete old pst files).

>> Extended the data drive from 279GB to 300GB (it was 90% full, now 84% full)
> 
> Growing filesystem in small chunks like this is a recipe for disaster.
>  Your free space map is always heavily fragmented and is very large.
> The more entries the filesystem driver must walk the more CPU you burn.
>  Recall we just discussed the table walking overhead of the md/RAID
> stripe cache?  Filesystem maps/tables/B+ trees are much, much larger
> structures.  When they don't fit it cache we read memory, and when they
> don't fit in memory (remember you "pool" problem) we must read from disk.

Yes, I did try and run a defrag (win2000 version) on the volume. I was
fairly curious about whether this would have any advantage given the SSD
backed filesystem where random IO shouldn't matter. Though I did think
it might still offer some improvement if both free space and files were
contiguous. However, after running on two occasions for about 20 hours,
it added around 2 or 3 very narrow defragged sections with no real
progress. I think the defrag is either running very slowly as well,
and/or requires more free space to run more efficiently.

> If you've been expanding this NTFS this way for a while it would also
> explain some of your CPU burn at the DC.  FYI, XFS is a MUCH higher
> performance and much more efficient filesystem than NTFS ever dreamed of
> becoming, but even XFS suffers slow IO and CPU burn due to heavily
> fragmented free space.

Nope, it has had the same 300G HDD (279G) for at least 6 years (as far
as I know). I'm pretty sure is has only been extended by physical
replacement of the HDD from time to time.

The current plan is to upgrade to win2003, I'm hoping this will improve
performance equivalent to what is being achieved on the other 2003
servers, which should make the users happy again. I may increase the
disk space and have another crack at defrag prior to the upgrade since
the upgrade won't happen until next weekend at the earliest.

Regards,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au
