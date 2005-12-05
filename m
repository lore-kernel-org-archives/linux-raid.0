From: ross@jose.lug.udel.edu (Ross Vandegrift)
Subject: Re: RAID5 problem
Date: Sun, 4 Dec 2005 20:44:08 -0500
Message-ID: <20051205014408.GA20602@jose.lug.udel.edu>
References: <4392FB7C.6080600@gmx.de> <17299.25606.806494.749914@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17299.25606.806494.749914@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Alfons Andorfer <a_a@gmx.de>, linux-raid@vger.kernel.org, n@suse.de
List-Id: linux-raid.ids

On Mon, Dec 05, 2005 at 08:47:50AM +1100, Neil Brown wrote:
> You want to be running "mdadm --monitor".  You really really do!
> Anyone out there who is listening: if you have any md/raid arrays
> (other than linear/raid0) and are not running "mdadm --monitor",
> please do so.  Now.
> Also run "mdadm --monitor --oneshot --scan" (or similar) from a
> nightly cron job, so it will nag you about degraded arrays.

So very, very true - I was bitten by that bit of stupidity a few weeks
ago.  I also have a script in my /etc/bashrc that looks for any
degraded arrays in /proc/mdstat.  If it finds them it prints obnoxious
messages, beeps, and dumps out mdstat for instant examination.

Neil - did you get a chance to look at the syslog and text
messaging patches I posted?

-- 
Ross Vandegrift
ross@lug.udel.edu

"The good Christian should beware of mathematicians, and all those who
make empty prophecies. The danger already exists that the mathematicians
have made a covenant with the devil to darken the spirit and to confine
man in the bonds of Hell."
	--St. Augustine, De Genesi ad Litteram, Book II, xviii, 37
