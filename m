From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm and raid5 hot-rebuild problem on 2.5.67
Date: Thu, 17 Apr 2003 10:29:48 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16029.62844.25748.442530@notabene.cse.unsw.edu.au>
References: <1050536716.13739.6.camel@testlin.hades>
	<16028.46697.488363.56989@notabene.cse.unsw.edu.au>
	<1050544298.13739.9.camel@testlin.hades>
	<16028.47242.348607.436021@notabene.cse.unsw.edu.au>
	<1050545634.13739.14.camel@testlin.hades>
	<16028.60532.659544.421715@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Neil Brown on Wednesday April 16
To: Stef Telford <stef@chronozon.artofdns.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday April 16, neilb@cse.unsw.edu.au wrote:
> 
> Ok, this is wrong.  Bigtime.
> The spare has taken up postion 0 instead of 2.
> 
> I cannot immediately see what would be causing this.  The code looks
> right, but obviously isn't.  I'll try to see if I can reproduce it
> tomorrow.
> 

I haven't managed to reproduce it, but I'm faily sure that I know what
was happening.  I'll try to figure out the best way to fix it.

In the mean time, you can avoid the problem by not using raidstart at
all. 
Reboot your machine, with raidstart disabled (e.g. move /etc/raidtab
out of the way) and then us mdadm to start the array.  I think you
will need "mdadm --assemble --force" to start it.
That didn't work before because raidstart had already tried to started
it and failed and the array have been left in an inconsistant start.
I suggest the reboot to make sure the array is not in an inconsistant
state. 

NeilBrown
