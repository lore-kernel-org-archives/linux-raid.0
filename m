From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Please review: Slackware RAID How-To
Date: Thu, 20 May 2004 00:35:38 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200405200435.i4K4ZgB18007@www.watkins-home.com>
References: <200405200311.i4K3BIB17777@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200405200311.i4K3BIB17777@www.watkins-home.com>
To: 'Guy' <bugzilla@watkins-home.com>, 'John Lange' <john.lange@bighostbox.com>
Cc: 'LinuxRaid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I looked at the code.  The stride option only seems to align tables on a
boundary (stride size).  The stride size is only used to define the starting
point of a table, not the table size.  The stride size does not affect disk
writes as far as I can tell.  At least not directly.

Also, the change log talks about RAID0 stride size.  No comments on RAID5.
The comments are dated 1997 and 1998.  Maybe RAID5 came after 1997/1998.

Anyway, based on what I found in the code, I bet if you base "stride size"
on "chunk size" you will be fine.

But maybe "stride size" should be based on "stripe size" sometime in the
future!  See my comments below.

Guy

This is the code:
===========================================================================
This is the only place stride is used in the code.
From misc/mke2fs.c
/*
         * Allocate the block and inode bitmaps, if necessary
         */
        if (fs->stride) {
                start_blk = group_blk + fs->inode_blocks_per_group;
                start_blk += ((fs->stride * group) %
                              (last_blk - start_blk));
                if (start_blk > last_blk)
                        start_blk = group_blk;
        } else
                start_blk = group_blk;

===========================================================================
There was also some other hard coded STRIDE_LENGTH stuff.
STRIDE_LENGTH is NOT related to stride.
I think they should be the same.
The disk i/o is at a size of STRIDE_LENGTH.
If this was 1 stripe the RAID5, RAID0 or RAID6 software may go faster.
This hard coded 8 seems wrong to me.
I bet it matched the writers chunk size at the time, and maybe he planned to
make it a parameter after testing.

Also, next_update_incr is not used.  What if num/100 is < 1?
This line:
	next_update += num / 100;
Should be:
	next_update += next_update_incr;

From misc/mke2fs.c

#define STRIDE_LENGTH 8

/* Allocate the zeroizing buffer if necessary */
        if (!buf) {
                buf = malloc(fs->blocksize * STRIDE_LENGTH);
                if (!buf) {
                        com_err("malloc", ENOMEM,
                                _("while allocating zeroizing buffer"));
                        exit(1);
                }
                memset(buf, 0, fs->blocksize * STRIDE_LENGTH);
        }
        /* OK, do the write loop */
        next_update = 0;
        next_update_incr = num / 100;
        if (next_update_incr < 1)
                next_update_incr = 1;
        for (j=0; j < num; j += STRIDE_LENGTH, blk += STRIDE_LENGTH) {
                count = num - j;
                if (count > STRIDE_LENGTH)
                        count = STRIDE_LENGTH;
                retval = io_channel_write_blk(fs->io, blk, count, buf);
                if (retval) {
                        if (ret_count)
                                *ret_count = count;
                        if (ret_blk)
                                *ret_blk = blk;
                        return retval;
                }
                if (progress && j > next_update) {
                        next_update += num / 100;
                        progress_update(progress, blk);
                }
        }
        return 0;

==========================================================================




-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Guy
Sent: Wednesday, May 19, 2004 11:11 PM
To: 'John Lange'
Cc: 'LinuxRaid'
Subject: RE: Please review: Slackware RAID How-To

The man page says "strip size", not "chunk size", which is correct?

RAID5:
	"strip size" = ("Number of disks in array" - 1) * "chunk size"
RAID6:
	"strip size" = ("Number of disks in array" - 2) * "chunk size"

"Number of disks in array" does not include spares!

It would be GREAT for performance if writes were full strips at a time,
since no reads would be required.

I don't think it would help performance if writes were full chunks at a
time, since the target chunk would still need to be read to compute the
parity chunk.

Any filesystem gods out there?  Any opinions?

Guy


-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of John Lange
Sent: Wednesday, May 19, 2004 9:42 PM
To: Guy
Cc: 'LinuxRaid'
Subject: RE: Please review: Slackware RAID How-To

On Sun, 2004-05-16 at 23:51, Guy wrote:
> md2 has 4 disks with a chunk size of 128K.  Since only 3 disks are used
for
> data, and the filesystem block size is 4K, the stride size should be
> 128*3/4, or 96.
> Change:
> 	mke2fs -b 4096 -R stride=32 /dev/md2
> To:
> 	mke2fs -b 4096 -R stride=96 /dev/md2
> 
> My logic:
> 	"Stripe size" is "chunk size" times "number of data disks".
> 	From example:
> 		"chunk size" = 128
> 		"number of data disks" = "nr-raid-disks" - 1 (-2 if RAID6)

I think this is incorrect. At this point I defer to the
Software-RAID-HOWTO.

http://www.tldp.org/HOWTO/Software-RAID-HOWTO-5.html#ss5.10

From that document stride is chucksize/blocksize . Number of disks does
not enter into it.

So with a chunksize of 128, and a block size of 4 it would be:

128K/4K = 32 for stride.

If this is indeed correct I will be sure to expand that area of the
How-To so it is more clear.

Thanks very much for your feedback.

Regards,

John Lange

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


