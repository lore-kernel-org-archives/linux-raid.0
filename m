From: Brad Campbell <brad@wasp.net.au>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10
 crashing repeatedly and hard)
Date: Wed, 05 Jan 2005 14:56:30 +0400
Message-ID: <41DBC7DE.509@wasp.net.au>
References: <Pine.LNX.3.96.1050105023623.27288A-100000@Maggie.Linux-Consulting.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.3.96.1050105023623.27288A-100000@Maggie.Linux-Consulting.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alvin Oga <aoga@ns.Linux-Consulting.com>
Cc: Andy Smith <andy@strugglers.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Alvin Oga wrote:
> 
> 	for swap ... i personally don't see any reason to mirror
> 	swap partitions ...
> 		- once the system dies, ( power off ), all temp
> 		data is useless unless one continues from a coredump 
> 		( from the same state as when it went down initially )

I beg to differ on this one. Having spend several weeks tracking down random processes dying on a 
machine that turned out to be a bad sector in the swap partition, I have had great results by 
running swap on a RAID-1. If you develop a bad sector in a non-mirrored swap, bad things happen 
indeterminately and can be a royal PITA to chase down. It's just a little extra piece of mind.

Regards,
Brad
