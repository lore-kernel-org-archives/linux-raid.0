From: keld@keldix.com
Subject: Re: RAID 10 far and offset on-disk layouts
Date: Tue, 14 Jan 2014 11:06:37 +0100
Message-ID: <20140114100637.GA5043@www5.open-std.org>
References: <52BD8EDD.10809@assyoma.it> <20131227151927.GA4003@www5.open-std.org> <52BD9B4F.3000509@assyoma.it> <20131227154952.GA6539@www5.open-std.org> <52CE57D9.1030501@assyoma.it> <20140113102021.1ef3e203@notabene.brown> <52D3A962.4000308@assyoma.it> <20140113204534.737a98f6@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140113204534.737a98f6@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Gionatan Danti <g.danti@assyoma.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 13, 2014 at 08:45:34PM +1100, NeilBrown wrote:
> On Mon, 13 Jan 2014 09:52:50 +0100 Gionatan Danti <g.danti@assyoma.it> wrote:
> 
> I think I know what you are talking about now.  The md driver in the kernel
> supports two sorts of 'far' or 'offset' layouts for arrays where the number
> of devices is not an integer multiple of the number of copies.
> This has been supported in Linux since v3.9. but is not yet supported by
> mdadm.

Hmm, we discussed also the new layouts for when the number of drives are 
a whole multiple of the number of copies. That layout should follow the same 
principles.

How do I generate the new format on kernel 3.9?

best regards
keld
