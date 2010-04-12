From: MRK <mrk@shiftmail.org>
Subject: Re: stuck tasks
Date: Mon, 12 Apr 2010 15:38:05 +0200
Message-ID: <4BC3223D.6020403@shiftmail.org>
References: <hputbs$qq2$1@dough.gmane.org> <4BC2FE9E.9040802@shiftmail.org>
 <hpuvbb$13t$1@dough.gmane.org> <4BC316EC.9040808@shiftmail.org>
 <hpv5kt$o52$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <hpv5kt$o52$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeremy Sanders <jeremy@jeremysanders.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/12/2010 03:02 PM, Jeremy Sanders wrote:
> It's not doing anything else on that drive. I think it would be faster but
> the option  CONFIG_MULTICORE_RAID456 was switched on in this kernel, so
> there are lots of async processes fighting each other (190 of them on this
> system).
>    

Oh it's this one then. I read it has already been discussed here... you 
really need to remove the multicore implementation: it's experimental as 
of now and *much* slower than single core. I don't know why the your 
distro maintainer has activated it. What distro is that? Someone should 
probably tell the maintainers to disable it by default. I think all your 
problems will go away if you can recompile with multicore off.
