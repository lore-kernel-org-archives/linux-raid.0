From: Neil Brown <neilb@suse.de>
Subject: Re: Is it possible to recover data after resync?
Date: Thu, 20 Jul 2006 13:14:09 +1000
Message-ID: <17598.62721.936579.64693@cse.unsw.edu.au>
References: <17598.55179.66969.564751@cse.unsw.edu.au>
	<20060720022718.36299.qmail@web50213.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Alex Davis on Wednesday July 19
Sender: linux-raid-owner@vger.kernel.org
To: Alex Davis <alex14641@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday July 19, alex14641@yahoo.com wrote:
> > 
> > > 
> > > Is there any way to recover the original data?
> > 
> > Well, if you got all the right devices in the right order, then your
> > data should be fine.  If not, I hope you have good backups, because
> > they are your only hope.
> > 
> > NeilBrown
> > 
> 
> So do I just keep doing mdadm -A /dev/md0 /dev/.... using different 
> permutations of the devices until my data shows up?
> 

Hard to say without precise details.  Maybe it's worth a try, maybe
not.

NeilBrown
