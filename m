From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: single cpu thread performance limit?
Date: Thu, 11 Aug 2011 20:05:35 -0500
Message-ID: <4E447C5F.2080204@hardwarefreak.com>
References: <CAACGR8sSieD1MLCEnY0Wv24pHd9xpcJ=mhduwGMCqo5A5ttZpw@mail.gmail.com>	<4E44265D.3050809@hardwarefreak.com> <CAACGR8to9iybX+fJ_CGYBFgR6XtgPoqCt8kFA4mpqo4d1jEMqw@mail.gmail.com> <4E4440DB.6020804@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E4440DB.6020804@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: mark delfman <markdelfman@googlemail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

On 8/11/2011 3:51 PM, Stan Hoeppner wrote:
> On 8/11/2011 2:37 PM, mark delfman wrote:
> 
>> FS:  An FS is not really an option for this solution, so we have not
>> tried this on this rig, but in the past the FS has degreaded the IOPS

>> Whilst a R0 on top of the R1/10's does offer some increase in
>> performance, linear does not :(
>> LVM R0 on top of the MD R1/10's does much the same results.
>> The limiter seems fixes on the single thread per R1/10

This seems to be the case.  The md processes apparently aren't threaded,
at least not when doing mirroring/+striping.  xfsbufd, xfssyncd, and
xfsaild are all threaded.

> This might provide you some really interesting results. :)  Take your 8
> flash devices, which are of equal size I assume, and create an md
> --linear array  on the raw device, no partitions (we'll worry about
> redundancy later).  Format this md device with:

A concat shouldn't use nearly as much CPU as a mirror or stripe.  Though
I don't know if one core will be enough here.  Test and see.

> ~$ mkfs.xfs -d ag=8 /dev/mdX
> 
> Mount it with:
> 
> ~$ mount -o inode64,logbsize=256,noatime,nobarrier /dev/mdX /test
> 
> (Too bad you're running 2.6.32 instead of 2.6.35 or above, as enabling
> the XFS delayed logging mount option would probably bump your small file
> block IOPS to well over a million, if the hardware is actually up to it.)
> 
> Now, create 8 directories, say test[1-8].  XFS drives parallelism
> through allocation groups.  Each directory will be created in a
> different AG.  Thus, you'll end up with one directory per SSD, and any
> files written to that directory will go that that same SSD.  Thus,
> writing files to all 8 directories in parallel will get you near perfect
> scaling across all disks, with files, not simply raw blocks.

In actuality, since you're running up against CPU vs IOPs, it may be
better here to create 32 or even 64 allocation groups and spread files
evenly across them.  IIRC, each XFS file IO gets its own worker thread,
so you'll be able to take advantage of all 16 cores in the box.  The
kernel IO is more than sufficiently threaded.

You mentioned above that using a filesystem isn't really an option.  As
I see it, given the lack of md's lateral (parallel) scalability with
your hardware and workload, you may want to evaluate the following ideas:

1.  Upgrade to 2.6.38 or later.  There have been IO optimizations since
2.6.32, though I'm not sure WRT the md code itself.

2.  Try the XFS option.  It may or may not work in your case, but it
will parallelize to hundreds of cores when writing hundreds of files
concurrently.  The trick is matching your workload to it, vice versa.
If you're writing single large files, it's likely not going to
parallelize.  If you can't use a filesystem...

3.  mdraid on your individual cores can't keep up with your SSDs, so:
    A.  Switch to 24 SLC SATA SSDs attached to 3* 8 port LSI SAS HBAs:
http://www.lsi.com/products/storagecomponents/Pages/LSISAS9211-8i.aspx
        which will give you 12 mdraid1 processes instead of 4.  Use
        cpumemsets to lock the 12 mdraid1 processes to 12 specific
        cores, and the mdraid0 process to another core.  And disable HT.
    B.  Swap the CPUs for higher frequency models, though it'll gain you
        little and cost quite a bit for four 3.6GHz Xeon W5590s

I'm sure you've already thought of these options, but I figured I'd get
them in Google.

-- 
Stan
