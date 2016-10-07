From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 1/2] RAID1: ignore discard error
Date: Fri, 7 Oct 2016 10:42:49 -0700
Message-ID: <20161007174249.GB37192@kernel.org>
References: <36b0390e404e6021f2aec98ee87c074eef6dc6bb.1475788662.git.shli@fb.com>
 <CALjAwxhSrcCaePBW0co1wSTNh0i3o0q09BKXeyeKtO_PRn+5_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALjAwxhSrcCaePBW0co1wSTNh0i3o0q09BKXeyeKtO_PRn+5_w@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org, Kernel-team@fb.com, "v3.6" <stable@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Oct 07, 2016 at 11:53:07AM +0100, Sitsofe Wheeler wrote:
> On 6 October 2016 at 22:20, Shaohua Li <shli@fb.com> wrote:
> > Sitsofe,
> > could you try if this patch fixes the issue too please?
> 
> As with with the previous patch the BUG_ON/crash is fixed and as
> before dmesg only says this now:
> [   17.884175] sd 0:0:1:0: [sdb] tag#0 FAILED Result: hostbyte=DID_OK
> driverbyte=DRIVER_SENSE
> [   17.884180] sd 0:0:1:0: [sdb] tag#0 Sense Key : Illegal Request [current]
> [   17.884185] sd 0:0:1:0: [sdb] tag#0 Add. Sense: Invalid command
> operation code
> [   17.884190] sd 0:0:1:0: [sdb] tag#0 CDB: Write same(16) 93 08 00 00
> 00 00 00 00 40 80 00 00 08 00 00 00
> [   17.884196] blk_update_request: critical target error, dev sdb, sector 16512
> [   17.884205] sd 0:0:2:0: [sdc] tag#1 FAILED Result: hostbyte=DID_OK
> driverbyte=DRIVER_SENSE
> [   17.884208] sd 0:0:2:0: [sdc] tag#1 Sense Key : Illegal Request [current]
> [   17.884211] sd 0:0:2:0: [sdc] tag#1 Add. Sense: Invalid command
> operation code
> [   17.884215] sd 0:0:2:0: [sdc] tag#1 CDB: Write same(16) 93 08 00 00
> 00 00 00 00 40 80 00 00 08 00 00 00
> [   17.884217] blk_update_request: critical target error, dev sdc, sector 16512
> [   17.924716] Buffer I/O error on dev dm-0, logical block 0, async page read
> 
> (sd[bc] are the devices the RAID is using)
> 
> However this time around blkdiscard doesn't return an error (despite
> the discard not being done) and is quiet. It's hard to say if this is
> desirable given that the underlying devices switch to saying they
> don't support discard but perhaps that's part of a different
> discussion.

Yep, I think the spec doesn't require discard IO returns error. We probably can
make this smarter later in MD

> Tested-by: Sitsofe Wheeler <sitsofe@gmail.com>

Thanks for the testing, I'll queue the two patches.

Thanks,
Shaohua
