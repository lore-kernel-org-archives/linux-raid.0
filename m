From: Neil Brown <neilb@suse.de>
Subject: Re: Strange intermittant errors + RAID doesn't fail the disk.
Date: Fri, 7 Jul 2006 08:05:47 +1000
Message-ID: <17581.35131.123710.652968@cse.unsw.edu.au>
References: <bb145bd20606300932x2268822k78561e549996aef3@mail.gmail.com>
	<17573.52096.655463.808666@cse.unsw.edu.au>
	<bb145bd20606302313x557f94d8xd69cce83731e2a4b@mail.gmail.com>
	<bb145bd20607060601x33519be7tb4c4812ab54cc7c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Christian Pernegger on Thursday July 6
Sender: linux-raid-owner@vger.kernel.org
To: Christian Pernegger <pernegger@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday July 6, pernegger@gmail.com wrote:
> > > I suggest you find a SATA related mailing list to post this to (Look
> > > in the MAINTAINERS file maybe) or post it to linux-kernel.
> 
> linux-ide couldn't help much, aside from recommending a bleeding-edge
> patchset which should fix a lot of things SATA:
> http://home-tj.org/files/libata-tj-stable/
> 
> What fixed the error, though, was exchanging one of the cables. (Just
> my luck, it was new and supposedly quality, ... oh well)
> 
> I'm still interested in why the md code didn't fail the disk. While it
> was 'up' any access to the array would hang for a long time,
> ultimately fail and corrupt the fs to boot. When I failed the disk
> manually everything was fine (if degraded) again.

md is very dependant on the driver doing the right thing.  It doesn't
do any timeouts or anything like that - it assumes the driver will. 
md simply trusts the return status from the drive, and fails a drive
if and only if a write to the drive is reported as failing (if a read
fails, md trys to over-write with good data first).

I don't know exactly how the driver was responding to the bad cable,
but it clearly wasn't returning an error, so md didn't fail it.

NeilBrown
