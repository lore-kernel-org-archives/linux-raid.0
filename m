From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: is "replaceable" in 3.2 considered stable
Date: Wed, 07 Nov 2012 09:42:03 +0800
Message-ID: <5099BC6B.7030500@fnarfbargle.com>
References: <alpine.DEB.2.00.1211050546420.13802@uplift.swm.pp.se> <20121105162227.7bc5c103@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121105162227.7bc5c103@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/11/12 13:22, NeilBrown wrote:

>
> Try it.  If it works for you, we can be more confident that it is stable :-)
>
> Seriously I think it is safe to try but I won't promise that nothing will go
> wrong.  I do promise that if something goes wrong (which is fairly unlikely),
> I'll do my best to help you fix it, and think it is extremely unlikely that
> the experiment will cause data loss.

I have a test system set up at the moment with a RAID10 n,2 across 6 1TB 
drives + 2 spares.

I've run several hot-replace tests using 3.6.2 and found it works as 
advertised.

I also have two drives with hard write errors (excellent for failure 
testing), and trying to replace a drive with one that contains a write 
error fails the replace as you would expect.

The test machine is on UPS, so I have not done any testing that involves 
reboots during a re-sync.

