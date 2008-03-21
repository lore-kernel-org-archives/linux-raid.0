From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Redundancy check using "echo check > sync_action": error
	reporting?
Date: Fri, 21 Mar 2008 13:13:48 -0400
Message-ID: <20080321171348.GK7991@mit.edu>
References: <47DD2CD7.2090802@tuxes.nl> <20080316161451.0d17fd22@szpak> <47E26775.3000500@tuxes.nl> <20080320134747.GA28114@cthulhu.home.robinhill.me.uk> <47E2725C.1020206@tuxes.nl> <20080320163551.GG13719@mit.edu> <47E2EE64.5080101@rabbit.us> <47E3C504.3010700@tmr.com> <47E3CBAF.4090808@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47E3CBAF.4090808@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: Bill Davidsen <davidsen@tmr.com>, Bas van Schaik <bas@tuxes.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Mar 21, 2008 at 03:52:31PM +0100, Peter Rabbitson wrote:
> I was actually specifically advocating that md must _not_ do anything on 
> its own. Just provide the hooks to get information (what is the current 
> stripe state) and update information (the described repair extension). The 
> logic that you are describing can live only in an external app, it has no 
> place in-kernel.

Why not?  If md doesn't do anything on its own, then when it detects a
disagreement between the data and the two parity blocks, it has two
choices (a) return possibly incorrect data to the application, or (b)
return an I/O error and cause the application to blow up.

Sure, it could then give the information so that the external repair
tool can fix it up after the fact, but that seems like a really lousy
thing to do as far as the original application is concerned.  (Or I
suppose you could try to block the userspace application until the
repair tool has a chance to do automatically what md could have done
automatically in the kernel anyway, but that has other problems.)

So what's the harm in having an option where md does exactly what ECC
memory does, which is when it can fix things up, to do so?  I bet most
system administrators would turn it on in a heartbeat.

       	     	      	      	      	     - Ted
