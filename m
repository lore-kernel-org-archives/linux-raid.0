From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: feature suggestion to handle read errors during re-sync of raid5
Date: Sat, 30 Jan 2010 19:04:29 +0000
Message-ID: <4B6482BD.6090102@anonymous.org.uk>
References: <alpine.DEB.1.10.1001301331560.15329@uplift.swm.pp.se> <4B6471A1.2070407@texsoft.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B6471A1.2070407@texsoft.it>
Sender: linux-raid-owner@vger.kernel.org
To: Giovanni Tessore <giotex@texsoft.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 30/01/2010 17:51, Giovanni Tessore wrote:
> [...]  Having the OS
> recover and rewrite the sectors makes me feel back in the past, when 
> under DOS we used PCTools and other utilities to do this recovery stuff 
> on ST-506 drives .... and this works well on raid, but in sinlge disk 
> configuration, shouldn't these be data loss?
> 
> I'm confused... how much are modern disks reliable?

I think the problem is that modern discs haven't got more reliable, but 
they have got much, much bigger; "modern" 2G discs had a read error rate 
of 1 bit per 10^14, and current 2T discs have the same, so while on a 2G 
disc you could read the whole surface of the disc tens of thousands of 
times before being likely to get a read error, now it's only tens of 
times. Someone did recently post links to a formal article analysing 
this subject to this list, but I can't find it :-(

Cheers,

John.
