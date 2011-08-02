From: Aaron Scheiner <blue@aquarat.za.net>
Subject: Re: Grub-install, superblock corrupted/erased and other animals
Date: Tue, 2 Aug 2011 18:24:45 +0200
Message-ID: <CADz4AWFJHah=OkZ0JaC8ZZD+E13D6tOvhz7cRR0oc19OfsOQew@mail.gmail.com>
References: <CADz4AWHJU5GGBji9uVbvGjPZCZ0CxseiPsQbssCULWxqyKvG8A@mail.gmail.com>
 <20110802163907.29fc40b4@notabene.brown> <4E37AEE8.1080108@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E37AEE8.1080108@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

wow... I had no idea XFS was that complex, great for performance,
horrible for file recovery :P . Thanks for the explanation.

Based on this the scalpel+lots of samples approach might not work...
I'll investigate XFS a little more closely, I just assumed it would
write big files in one continuous block.

This makes a lot of sense; I reconstructed/re-created the array using
a random drive order, scalpel'ed the md device for the start of the
video file and found it. I then dd'ed that out to a file on the hard
drive and then loaded that into a hex editor. The file ended abruptly
after about +/-384KBs. I couldn't find any other data belonging to the
file within 50MBs around the the sample scalpel had found.

Thanks again for the info.

On Tue, Aug 2, 2011 at 10:01 AM, Stan Hoeppner <stan@hardwarefreak.com>=
 wrote:
> On 8/2/2011 1:39 AM, NeilBrown wrote:
>> On Wed, 27 Jul 2011 14:16:52 +0200 Aaron Scheiner <blue@aquarat.za.n=
et> wrote:
>
>>> Do these segments follow on from each other without interruption or=
 is
>>> there some other data in-between (like metadata? I'm not sure where
>>> that resides).
>>
>> That depends on how XFS lays out the data. =A0It will probably be mo=
stly
>> contiguous, but no guarantees.
>
> Looks like he's still under the 16TB limit (8*2TB drives) so this is =
an
> 'inode32' XFS filesystem. =A0inode32 and inoe64 have very different
> allocation behavior. =A0I'll take a stab at an answer, and though the
> following is not "short" by any means, it's not nearly long enough to
> fully explain how XFS lays out data on disk.
>
> With inode32, all inodes (metadata) are stored in the first allocatio=
n
> group, maximum 1TB, with file extents in the remaining AGs. =A0When t=
he
> original array was created (and this depends a bit on how old his
> kernel/xfs module/xfsprogs are) mkfs.xfs would have queried mdraid fo=
r
> the existence of a stripe layout. =A0If found, mkfs.xfs would have cr=
eated
> 16 allocation groups of 500GB each, the first 500GB AG being reserved
> for inodes. =A0inode32 writes all inodes to the first AG and distribu=
tes
> files fairly evenly across top level directories in the remaining 15 =
AGs.
>
> This allocation parallelism is driven by directory count. =A0The more=
 top
> level directories the greater the filesystem write parallelism. =A0in=
ode64
> is much better as inodes are spread across all AGs instead of being
> limited to the first AG, giving metadata heavy workloads a boost (e.g=
=2E
> maildir). =A0inode32 filesystems are limited to 16TB in size, while
> inode64 is limited to 16 exabytes. =A0inode64 requires a fully 64 bit
> Linux operating system, and though inode64 scales far beyond 16TB, on=
e
> can use inode64 on much smaller filesystems for the added benefits.
>
> This allocation behavior is what allows XFS to have high performance
> with large files as free space management within and across multiple
> allocation groups keeps file fragmentation to a minimum. =A0Thus, the=
re
> are normally large spans of free space between AGs, on a partially
> populated XFS filesystem.
>
> So, to answer the question, if I understood it correctly, there will
> indeed be data spread all over all of the disks with large free space
> chunks in between. =A0The pattern of files on disk will not be contig=
uous.
> =A0Again, this is by design, and yields superior performance for larg=
e
> file workloads, the design goal of XFS. =A0It doesn't do horribly bad=
 with
> many small file workloads either.
>
> --
> Stan
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
