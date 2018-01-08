From: Wolfgang Denk <wd@denx.de>
Subject: Re: Growing RAID10 with active XFS filesystem
Date: Mon, 08 Jan 2018 17:24:54 +0100
Message-ID: <20180108162454.67378240749@gemini.denx.de>
References: <4892a03d-018c-8281-13d3-4fcc7acd2bb8@gmail.com> <232deaaa-7306-a01b-567f-ca5c74dc6077@suse.com> <5A538B30.4080601@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <5A538B30.4080601@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Guoqing Jiang <gqjiang@suse.com>, mdraid.pkoch@dfgh.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Wol,

In message <5A538B30.4080601@youngman.org.uk> you wrote:
>
> You extend the filesystem *after* you've grown the array. The act of
> growing the array has caused the filesystem to crash. That should NOT
> happen - the act of growing the array should be *invisible* to the
> filesystem.

Not if this causes any hard I/O errors...

> In other words, one or more of the following three are true :-
> 1) The OP has been caught by some random act of God
> 2) There's a serious flaw in "mdadm --grow"
> 3) There's a serious flaw in xfs

The original log contained this:

| XFS (md5): metadata I/O error: block 0x12c08f360
| ("xfs_trans_read_buf_map") error 5 numblks 16
| XFS (md5): xfs_imap_to_bp: xfs_trans_read_buf() returned error 5.
| XFS (md5): metadata I/O error: block 0x12c08f360
| ("xfs_trans_read_buf_map") error 5 numblks 16
| XFS (md5): xfs_imap_to_bp: xfs_trans_read_buf() returned error 5.
| XFS (md5): metadata I/O error: block 0xebb62c00
| ("xfs_trans_read_buf_map") error 5 numblks 16
| XFS (md5): xfs_imap_to_bp: xfs_trans_read_buf() returned error 5.
| ...
| ... lots of the above messages deleted
| ...
| XFS (md5): xfs_do_force_shutdown(0x1) called from line 138 of file
| fs/xfs/xfs_bmap_util.c.  Return address = 0xffffffff8113908f
| XFS (md5): metadata I/O error: block 0x48c710b00 ("xlog_iodone") error 5
| numblks 64
| XFS (md5): xfs_do_force_shutdown(0x2) called from line 1170 of file
| fs/xfs/xfs_log.c.  Return address = 0xffffffff8117cdf4
| XFS (md5): Log I/O Error Detected.  Shutting down filesystem

To me this looks as if during the growing of the array some hard I/O
errors happenend.  That may have been triggered by the growing of
the array. but only as fas as it caused additional disk load /
reading of otherwise idle areas.

I cannot see any indications for 2) or 3) here, so yes, it was 1),
if you consider spurious I/O aerrors as such.

Or am I missing soething else?


Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Experience is that marvelous thing that enable  you  to  recognize  a
mistake when you make it again.                   - Franklin P. Jones
