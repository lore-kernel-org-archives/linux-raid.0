From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: from raidtools2 to mdadm
Date: Fri, 24 Jun 2005 12:01:48 +1000
Message-ID: <17083.27020.649915.592929@cse.unsw.edu.au>
References: <42B7A866.1080802@tequila.co.jp>
	<17079.43900.652982.735401@cse.unsw.edu.au>
	<42B7ACDA.1000605@tequila.co.jp>
	<17079.45804.485652.77989@cse.unsw.edu.au>
	<42B9B274.7050109@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Davidsen on Wednesday June 22
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Clemens Schwaighofer <cs@tequila.co.jp>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday June 22, davidsen@tmr.com wrote:
> 
> So is there no way to ask mdadm to take what's running and create a 
> config to make it happen again? Telling people to cread the man pages 
> for a utility they did not use by choice and create a config file which 
> could result in losing their data if it's wrong is a deterent to an 
> upgrade, I suspect.

There is a complexity in that devices can change there names across
reboot, and mdadm has no way to know a minimal set of possible new
names.

You could:
  echo DEVICES partitions > /etc/mdadm.conf
  mdadm -Ds | grep -v devices >> /etc/mdadm.conf

and then
  mdadm -As

should re-assemble  everything properly at boot time.
However this might not handle stacked devices (raid0 comprised for
raid1s) very well (maybe an enhancement for the next mdadm?).

A bad config file is unlikely to cause data loss.  It might result it
data not being visible until the problem is fixed.

I'm working towards making auto-assembly more bullet-proof, but it is
not trivial, and I would rather it not give the appearance of working
correctly until it really does (in contrast to 'raidstart' which gives
the appearance of working correctly until a drive fails.  Then it
fails too :-( )

NeilBrown
