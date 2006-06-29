From: Neil Brown <neilb@suse.de>
Subject: Re: Drive issues in RAID vs. not-RAID ..
Date: Thu, 29 Jun 2006 13:51:57 +1000
Message-ID: <17571.20061.557898.910635@cse.unsw.edu.au>
References: <bb145bd20606221008p131d4daem289a6b9300757c66@mail.gmail.com>
	<62b0912f0606221104q2f47f574i86441efed5831957@mail.gmail.com>
	<bb145bd20606221250y147d0a0bk1e371a3078adc09e@mail.gmail.com>
	<62b0912f0606221511p74a78ca5id4b5d3f870258815@mail.gmail.com>
	<Pine.LNX.4.64.0606272241040.26384@router.windsormachine.com>
	<bb145bd20606280025x55f0090x2e6d6763be307b97@mail.gmail.com>
	<Pine.LNX.4.56.0606280917080.6357@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Gordon Henderson on Wednesday June 28
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday June 28, gordon@drogon.net wrote:
> 
> I've seen a few comments to the effect that some disks have problems when
> used in a RAID setup and I'm a bit preplexed as to why this might be..
> 
> What's the difference between a drive in a RAID set (either s/w or h/w)
> and a drive on it's own, assuming the load, etc. is roughly the same in
> each setup?
> 
> Is it just "bad feeling" or is there any scientific reasons for it?

I don't think that 'disks' have problems being in a raid, but I
believe some controllers do (though I don't know whether it is the
controller or the driver that is at fault).  RAID make concurrent
requests much more likely and so is likely to push hard at any locking
issues.

NeilBrown
