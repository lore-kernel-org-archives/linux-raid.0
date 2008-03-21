From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Redundancy check using "echo check > sync_action": error	reporting?
Date: Fri, 21 Mar 2008 19:01:43 -0400
Message-ID: <47E43E57.5010409@tmr.com>
References: <47DD2CD7.2090802@tuxes.nl> <20080316161451.0d17fd22@szpak> <47E26775.3000500@tuxes.nl> <20080320134747.GA28114@cthulhu.home.robinhill.me.uk> <47E2725C.1020206@tuxes.nl> <20080320163551.GG13719@mit.edu> <47E2EE64.5080101@rabbit.us> <47E3C504.3010700@tmr.com> <47E3CBAF.4090808@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47E3CBAF.4090808@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: Theodore Tso <tytso@MIT.EDU>, Bas van Schaik <bas@tuxes.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter Rabbitson wrote:
> I was actually specifically advocating that md must _not_ do anything 
> on its own. Just provide the hooks to get information (what is the 
> current stripe state) and update information (the described repair 
> extension). The logic that you are describing can live only in an 
> external app, it has no place in-kernel.

So you advocate the current code being in the kernel, which absent a 
hardware error makes blind assumptions about which data is valid and 
which is not and in all cases hides the problem, instead of the code I 
proposed, which in some cases will be able to avoid action which is 
provably wrong and never be less likely to do the wrong thing than the 
current code?

Currently the "repair" action (which *is* in the kernel now) takes no 
advantage of the additional information available in these cases I 
noted. By what logic do you conclude that the user meant "hide the 
error" when using the "repair" action? What I propose is never less 
likely to be correct than what the current code does, why would you not 
want to improve the chances of getting the repair correct?

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


