From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: Re: Redundancy check using "echo check > sync_action": error	reporting?
Date: Fri, 21 Mar 2008 20:45:10 -0300
Message-ID: <18404.18566.101449.717359@fisica.ufpr.br>
References: <47DD2CD7.2090802@tuxes.nl>
	<20080316161451.0d17fd22@szpak>
	<47E26775.3000500@tuxes.nl>
	<20080320134747.GA28114@cthulhu.home.robinhill.me.uk>
	<47E2725C.1020206@tuxes.nl>
	<20080320163551.GG13719@mit.edu>
	<47E2EE64.5080101@rabbit.us>
	<47E3C504.3010700@tmr.com>
	<47E3CBAF.4090808@rabbit.us>
	<47E43E57.5010409@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47E43E57.5010409@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen (davidsen@tmr.com) wrote on 21 March 2008 19:01:
 >Peter Rabbitson wrote:
 >> I was actually specifically advocating that md must _not_ do anything 
                                                *************************
 >> on its own. Just provide the hooks to get information (what is the 
    **********
 >> current stripe state) and update information (the described repair 
 >> extension). The logic that you are describing can live only in an 
 >> external app, it has no place in-kernel.
 >
 >So you advocate the current code being in the kernel, which absent a 
 >hardware error makes blind assumptions about which data is valid and 
 >which is not and in all cases hides the problem, instead of the code I 
 >proposed, which in some cases will be able to avoid action which is 
 >provably wrong and never be less likely to do the wrong thing than the 
 >current code?

The current code doesn't do anything on its own, it must be invoked by
the user, which is an important difference.

I agree that blindingly setting parity is not good; that's an argument
for removing it from the kernel, not adding something :-)

Why is it there? This is for Neil to answer; I merely conjecture that
it was already there. For example, it's necessary after a raid5 array
is created, because it's done creating an n-1 degraded array and
adding the last disk afterwards. It's also done when an array is
dirty. This is a situation where it's done without asking the user but
it seems to me that in this case that's the right action: if the
parity doesn't agree with the data it's either because the parity was
not yet updated at the moment of the unclean shutdown or because it
was updated but not the data itself. In both cases the parity should
reflect the current data situation.

The /sys/..../syn_action is just an interface added much later to
trigger the code. The check action is useful but I think repair is too
risky. I doubt it should be available.
