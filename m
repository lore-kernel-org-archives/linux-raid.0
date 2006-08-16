From: andy liebman <andyliebman@aol.com>
Subject: Re: Imaging Mirrored OS Drives
Date: Wed, 16 Aug 2006 18:20:42 -0400
Message-ID: <44E39A3A.50909@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Luca Berra <bluca@comedia.it>
List-Id: linux-raid.ids

> On Wed, Aug 16, 2006 at 01:05:39PM -0400, andy liebman wrote:
> if the imaging software is not too smart and creates the partitions and
> filesystems with the exact same size as the original, yes.
> (i mean that there should be some space between the end of the
> filesystem and the end of the partition to store the md superblock)
> 
>>2) Furthermore, if the above is possible, in creating the arrays on the 
>>new drives is there a way to force mdadm to give the arrays specific 
>>UUID numbers? It looks like I can do that with mdadm --update? Should I 
>>create the arrays first using the normal "mdadm -C" procedure, and then 
>>update the UUIDs?
> never tried that, let us know how you fare.
> 
> L.
> 
> -- 
> Luca Berra -- bluca@comedia.it
>         Communication Media & Services S.r.l.


Well, I booted with Mandriva One (Live CD), created NEW raid1 arrays 
(md0, md1, md2 and md3) on top of the 4 pairs of partitions 
(/dev/sd{a,b}1, /dev/sd{a,b}2, etc. corresponding to "/boot", "/", 
"swap" and "/home")

      mdadm -C -ayes /dev/md0 -n2 -l0 /dev/sd{a,b}1  and so on...

and when I mounted the md devices all of the data seemed to be there.

Then I stopped the arrays and changed the UUIDs on all the md devices so 
that the UUIDs matched the original UUIDs from the drives that I was 
copying from when I made the images.

      mdadm -Av -ayes /dev/md0 --update=uuid --uuid=xxxxxxxx /dev/sd{a,b}1

I probably could have just created the arrays in the first place 
specifying the uuids.

Anyway, after making those changes, I rebooted and the RAIDED OS just 
came up "like magic".  I was a little worried about whether the 
filesystem would be okay. Rebooted with Mandriva One and ran "e2fsck 
-fv" on all md devices (to force a thorough check and be verbose) and 
all checked out okay as well.

I say, "hmmm". I never expected this to work. Compared to cloning a 
RAIDED OS by doing dd on each drive, partition by partition, this was 
fast! With this approach, it only takes about 15 minutes to produce a 
cloned RAIDED OS.

I'm still worried that something might be wrong, but I can't see what it 
is if it's there.

I promised I would put my "Single-Drive-OS-to-RAIDED-OS" recipe on the 
list. I'll do it tomorrow.

Andy
