From: Mike Fedyk <mfedyk@matchmail.com>
Subject: Re: BUG: Data corruption on Raid5 in Linux 2.6.0
Date: Sun, 28 Dec 2003 16:02:27 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031229000227.GC1882@matchmail.com>
References: <20031228000008.B2433@nettis.grimsta> <16366.28299.160756.494452@notabene.cse.unsw.edu.au> <20031228091722.B4400@nettis.grimsta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20031228091722.B4400@nettis.grimsta>
To: Daniel Brahneborg <daniel.com@wtnord.net>
Cc: Neil Brown <neilb@cse.unsw.edu.au>, mingo@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Dec 28, 2003 at 09:17:22AM +0100, Daniel Brahneborg wrote:
> I get the same problem without it, just a few more "dma_intr:
> DriveReady SeekComplete Error" in the syslog.

You are having hard drive problems.

 o check your cables
 o check your drives with smartmontools
