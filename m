From: Stef Telford <stef@chronozon.artofdns.com>
Subject: Re: mdadm and raid5 hot-rebuild problem on 2.5.67
Date: 17 Apr 2003 19:43:55 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1050623034.2093.11.camel@testlin.hades>
References: <1050536716.13739.6.camel@testlin.hades>
	 <16028.46697.488363.56989@notabene.cse.unsw.edu.au>
	 <1050544298.13739.9.camel@testlin.hades>
	 <16028.47242.348607.436021@notabene.cse.unsw.edu.au>
	 <1050545634.13739.14.camel@testlin.hades>
	 <16028.60532.659544.421715@notabene.cse.unsw.edu.au>
	 <16029.62844.25748.442530@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16029.62844.25748.442530@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

neil wrote
> I haven't managed to reproduce it, but I'm faily sure that I know what
> was happening.  I'll try to figure out the best way to fix it.
> 

okay, its solved at my end (as i jst informed the list
and yourself) but would rather no one else is 'bitten'
by this. again, it could be purely a semantical error
or display problem and there wasnt a 'real' error, 
but, i am skeptical of that (no offense meant)

> In the mean time, you can avoid the problem by not using raidstart at
> all. 
> Reboot your machine, with raidstart disabled (e.g. move /etc/raidtab
> out of the way) and then us mdadm to start the array.  I think you
> will need "mdadm --assemble --force" to start it.
> That didn't work before because raidstart had already tried to started
> it and failed and the array have been left in an inconsistant start.
> I suggest the reboot to make sure the array is not in an inconsistant
> state. 
> 

funnily enough, this is -exactly- what i did, i threw
away /etc/raidtab and even went so far as to mv the
raid* binaries into a directory under root ( go_away
i called it ;), once i jst stuck with using mdadm, the
actual operation was almost laughably easy. so, mea culpa :)

thanks and best wishes 
Stef Telford <stef@chronozon.artofdns.com>

