From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Wed, 5 Jan 2005 10:17:51 -0500
Message-ID: <200501051517.j05FHv925754@www.watkins-home.com>
References: <41DBC7DE.509@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41DBC7DE.509@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: 'Brad Campbell' <brad@wasp.net.au>, 'Alvin Oga' <aoga@ns.Linux-Consulting.com>
Cc: 'Andy Smith' <andy@strugglers.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I agree, but for a different reason.  Your reason is new to me.
I don't want a down system due to a single disk failure.
Loosing the swap disk would kill the system.

Maybe this is Peter's cause of frequent corruption?

I mirror everything, or RAID5.  Normally, no downtime due to disk failures.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Brad Campbell
Sent: Wednesday, January 05, 2005 5:57 AM
To: Alvin Oga
Cc: Andy Smith; linux-raid@vger.kernel.org
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10
crashing repeatedly and hard)

Alvin Oga wrote:
> 
> 	for swap ... i personally don't see any reason to mirror
> 	swap partitions ...
> 		- once the system dies, ( power off ), all temp
> 		data is useless unless one continues from a coredump 
> 		( from the same state as when it went down initially )

I beg to differ on this one. Having spend several weeks tracking down random
processes dying on a 
machine that turned out to be a bad sector in the swap partition, I have had
great results by 
running swap on a RAID-1. If you develop a bad sector in a non-mirrored
swap, bad things happen 
indeterminately and can be a royal PITA to chase down. It's just a little
extra piece of mind.

Regards,
Brad
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

