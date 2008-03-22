From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Redundancy check using "echo check > sync_action": error	reporting?
Date: Sat, 22 Mar 2008 13:19:11 -0400
Message-ID: <47E53F8F.3000703@tmr.com>
References: <47DD2CD7.2090802@tuxes.nl>	<20080316161451.0d17fd22@szpak>	<47E26775.3000500@tuxes.nl>	<20080320134747.GA28114@cthulhu.home.robinhill.me.uk>	<47E2725C.1020206@tuxes.nl>	<20080320163551.GG13719@mit.edu>	<47E2EE64.5080101@rabbit.us>	<47E3C504.3010700@tmr.com>	<47E3CBAF.4090808@rabbit.us>	<47E43E57.5010409@tmr.com> <18404.18566.101449.717359@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18404.18566.101449.717359@fisica.ufpr.br>
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Carvalho <carlos@fisica.ufpr.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Carlos Carvalho wrote:
> Bill Davidsen (davidsen@tmr.com) wrote on 21 March 2008 19:01:
>  >Peter Rabbitson wrote:
>  >> I was actually specifically advocating that md must _not_ do anything 
>                                                 *************************
>  >> on its own. Just provide the hooks to get information (what is the 
>     **********
>  >> current stripe state) and update information (the described repair 
>  >> extension). The logic that you are describing can live only in an 
>  >> external app, it has no place in-kernel.
>  >
>  >So you advocate the current code being in the kernel, which absent a 
>  >hardware error makes blind assumptions about which data is valid and 
>  >which is not and in all cases hides the problem, instead of the code I 
>  >proposed, which in some cases will be able to avoid action which is 
>  >provably wrong and never be less likely to do the wrong thing than the 
>  >current code?
>
> The current code doesn't do anything on its own, it must be invoked by
> the user, which is an important difference.
>
>   
Difference from what? Is issuing the 'repair' action on its own? How 
would adding code which lets that repair have a higher chance of success 
be bad? Sector consistency errors don't show up during normal operation, 
there's no hardware error, just bad data. It only shows up during 
'check' or 'repair,' so the recovery would never be triggered without 
express user request.

> I agree that blindingly setting parity is not good; that's an argument
> for removing it from the kernel, not adding something :-)
>
> Why is it there? This is for Neil to answer; I merely conjecture that
> it was already there. For example, it's necessary after a raid5 array
> is created, because it's done creating an n-1 degraded array and
> adding the last disk afterwards. It's also done when an array is
> dirty. This is a situation where it's done without asking the user but
> it seems to me that in this case that's the right action: if the
> parity doesn't agree with the data it's either because the parity was
> not yet updated at the moment of the unclean shutdown or because it
> was updated but not the data itself. In both cases the parity should
> reflect the current data situation.
>
> The /sys/..../syn_action is just an interface added much later to
> trigger the code. The check action is useful but I think repair is too
> risky. I doubt it should be available.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   


-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


