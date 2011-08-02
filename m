From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Grub-install, superblock corrupted/erased and other animals
Date: Tue, 02 Aug 2011 03:01:44 -0500
Message-ID: <4E37AEE8.1080108@hardwarefreak.com>
References: <CADz4AWHJU5GGBji9uVbvGjPZCZ0CxseiPsQbssCULWxqyKvG8A@mail.gmail.com> <20110802163907.29fc40b4@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110802163907.29fc40b4@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Aaron Scheiner <blue@aquarat.za.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8/2/2011 1:39 AM, NeilBrown wrote:
> On Wed, 27 Jul 2011 14:16:52 +0200 Aaron Scheiner <blue@aquarat.za.net> wrote:

>> Do these segments follow on from each other without interruption or is
>> there some other data in-between (like metadata? I'm not sure where
>> that resides).
> 
> That depends on how XFS lays out the data.  It will probably be mostly
> contiguous, but no guarantees.

Looks like he's still under the 16TB limit (8*2TB drives) so this is an
'inode32' XFS filesystem.  inode32 and inoe64 have very different
allocation behavior.  I'll take a stab at an answer, and though the
following is not "short" by any means, it's not nearly long enough to
fully explain how XFS lays out data on disk.

With inode32, all inodes (metadata) are stored in the first allocation
group, maximum 1TB, with file extents in the remaining AGs.  When the
original array was created (and this depends a bit on how old his
kernel/xfs module/xfsprogs are) mkfs.xfs would have queried mdraid for
the existence of a stripe layout.  If found, mkfs.xfs would have created
16 allocation groups of 500GB each, the first 500GB AG being reserved
for inodes.  inode32 writes all inodes to the first AG and distributes
files fairly evenly across top level directories in the remaining 15 AGs.

This allocation parallelism is driven by directory count.  The more top
level directories the greater the filesystem write parallelism.  inode64
is much better as inodes are spread across all AGs instead of being
limited to the first AG, giving metadata heavy workloads a boost (e.g.
maildir).  inode32 filesystems are limited to 16TB in size, while
inode64 is limited to 16 exabytes.  inode64 requires a fully 64 bit
Linux operating system, and though inode64 scales far beyond 16TB, one
can use inode64 on much smaller filesystems for the added benefits.

This allocation behavior is what allows XFS to have high performance
with large files as free space management within and across multiple
allocation groups keeps file fragmentation to a minimum.  Thus, there
are normally large spans of free space between AGs, on a partially
populated XFS filesystem.

So, to answer the question, if I understood it correctly, there will
indeed be data spread all over all of the disks with large free space
chunks in between.  The pattern of files on disk will not be contiguous.
 Again, this is by design, and yields superior performance for large
file workloads, the design goal of XFS.  It doesn't do horribly bad with
many small file workloads either.

-- 
Stan
