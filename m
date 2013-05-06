From: Phil Turmel <philip@turmel.org>
Subject: Re: Failed during rebuild (raid5)
Date: Sun, 05 May 2013 23:21:49 -0400
Message-ID: <518721CD.2040108@turmel.org>
References: <51839E4F.7050102@midgaard.us> <CANU9nTneT2CRWJhdN=d87Hb7W9M+apQH+fRE-S+sieZ-W6+hjg@mail.gmail.com> <51866602.8000704@midgaard.us> <518693EF.6090802@midgaard.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <518693EF.6090802@midgaard.us>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Boman <aboman@midgaard.us>
Cc: Ole Tange <tange@binf.ku.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Andreas,

On 05/05/2013 01:16 PM, Andreas Boman wrote:

[trim /]

> Turns out the superblocks are there. I ran --examine on the disk instead
> of partition. OOps.

Please share the "--examine" reports for your array, and "smartctl -x"
for each disk, and anything from dmesg/syslog that relates to your array
or errors on its members.  (Your original post did say you would be able
to get log info.)

> I still have the problem with ddrescue being very slow, it is running at
> 512 B/s pretty much no matter what options I use. The ddrescued disk
> does NOT have a md superblock. I tried to ddrescue -i to skip and grab
> the last 3MB or so of the disk, that seemed to work, but I still don't
> have the superblock.
> 
> How do I find/recover the superblock from the original disk?

Superblocks are either at/near the beginning of the block device (v1.1 &
v1.2) or near the end (v0.90 and v1.0).  If you've already recovered
beginning and end, and it's still not there, then you won't find it.

It may have to be reconstructed as part of "--create --assume-clean",
but that is a dangerous operation.  You haven't yet shared enough
information to get good advice.

> After that is done I'll try to get the array up with 4 disks, then add
> the spare and have it rebuild. After that I'll add a disk to go to raid 6.

It may be wiser to get it running degraded and take a backup, but that
remains to be seen.  You haven't shown that you know why the first
rebuild failed.  Until that is understood and addressed, you probably
won't succeed in rebuilding onto a spare.

Phil
