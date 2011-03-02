From: NeilBrown <neilb@suse.de>
Subject: Re: Increasing maxsect of md devices?
Date: Thu, 3 Mar 2011 09:59:29 +1100
Message-ID: <20110303095929.25b800da@notabene.brown>
References: <4D6EC3FA.4030809@bartk.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D6EC3FA.4030809@bartk.us>
Sender: linux-raid-owner@vger.kernel.org
To: Bart Kus <me@bartk.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 02 Mar 2011 14:26:02 -0800 Bart Kus <me@bartk.us> wrote:

> Hello,
> 
> This seems contradictory:
> 
> jo ~ # blockdev --getiomin /dev/md5
> 524288
> jo ~ # blockdev --getioopt /dev/md5
> 4194304
> jo ~ # blockdev --getmaxsect /dev/md5
> 255
> jo ~ # blockdev --getbsz /dev/md5
> 4096
> jo ~ # blockdev --getss /dev/md5
> 512
> jo ~ #
> 
> Optimal IO size is reported as 4MB (and that is indeed the stripe size), 
> but maximum sectors per request is only 128kB?  How can software do 
> optimal 4MB IOs with the maxsect limit?  Does XFS care about this limit?

md/raid doesn't use 'requests' the any maximum is meaningless.
raid4/5/6 does have a 'stripe cache' which is a vaguely similar thing.  There
can sometimes be value in changing that.

The devices that the array are built from may have a 'maximum sectors per
request', but that probably isn't particularly related to chunk size.

BTW, where do you find "maximum sectors per request in only 128kB" in the
details you quoted - I don't see it.

NeilBrown

