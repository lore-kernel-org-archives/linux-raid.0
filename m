From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Multiple SSDs - RAID-1, -10, or stacked? TRIM?
Date: Thu, 10 Oct 2013 04:15:08 -0500
Message-ID: <5256701C.3090807@hardwarefreak.com>
References: <20131009123135.GT1779@bitfolk.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131009123135.GT1779@bitfolk.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/9/2013 7:31 AM, Andy Smith wrote:
> Hello,

Hello Andy.

> Due to increasing load of random read IOPS I am considering using 8
                            ^^^^^^^^^^^^^^^^

The data has to be written before it can be read.  Are you at all
concerned with write throughput, either random or sequential?  Please
read on.

> SSDs and md in my next server, instead of 8 SATA HDDs with
> battery-backed hardware RAID. I am thinking of using Crucial m500s.
> 
> Are there any gotchas to be aware of? I haven't much experience with
> SSDs.

Yes, there is one major gotcha WRT md/RAID and SSDs, which to this point
nobody has mentioned in this thread, possibly because it pertains to
writes, not reads.  Note my question posed to you up above.  Since I've
answered this question in detail at least a dozen times on this mailing
list, I'll simply refer you to one of my recent archived posts for the
details:

http://permalink.gmane.org/gmane.linux.raid/43984

> If these were normal HDDs then (aside from small partitions for
> /boot) I'd just RAID-10 for the main bulk of the storage. Is there
> any reason not to do that with SSDs currently?

The answer to this questions lies behind the link above.

> I think I read somewhere that offline TRIM is only supported by md
> for RAID-1, is that correct? If so, should I be finding a way to use
> four pairs of RAID-1s, or does it not matter?

Yes, but not because of TRIM.  But of course, you already read that in
the gmane post above.  That thread is void of another option I've
written about many a time, which someone attempted to parrot earlier.

Layer an md linear array atop RAID1 pairs, and format it with XFS.  XFS
is unique among Linux filesystems in that it uses what are called
allocation groups.  Take a pie (XFS filesystem atop linear array of 4x
RAID1 SSD pairs) and cut 4 slices (AGs).  That's basically what XFS does
with the blocks of the underlying device.  Now create 4 directories.
Now write four 1GB files, each into one directory, simultaneously.  XFS
just wrote each 1GB file to a different SSD, all in parallel.  If each
SSD can write at 500MB/s, you just achieved 2GB/s throughput, -without-
using a striped array.  No other filesystem can achieve this kind of
throughput without a striped array underneath.  And yes, TRIM will work
with this setup, both DISCARD and batch fitrim.

Allocation groups enable fantastic parallelism in XFS with a linear
array over mirrors, and this setup is perfect for both random write and
read workloads.  But AGs on a linear array can also cause a bottleneck
if the user doesn't do a little planning of directory and data layout.
In the scenario above we have 4 allocation groups, AG0-AG3, each
occupying one SSD.  The first directory you create will be created in
AG0 (SSD0), the 2nd AG1 (SSD1), the 3rd AG2 (SSD2), and the 4th AG3
(SSD3).  The 5th directory will be created on AG0, as well as the 9th,
and so on.  So you should already see the potential problem here.  If
you put all of your files in a single directory, or in multiple
directories that all reside within the same AG, they will all end up on
only one of your 4 SSDs.  Or at least up to the point you run out of
free space, in which case XFS will "spill" new files into the next AG.

To be clear, the need for careful directory/file layout to achieve
parallel throughput pertains only to the linear concatenation storage
architecture described above.  If one is using XFS atop a striped array
then throughput, either sequential or parallel, is -not- limited by
file/dir placement across the AGs, as all AGs are striped across the disks.

-- 
Stan

