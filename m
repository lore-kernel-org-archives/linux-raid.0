From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: resync patch & Neil's recent patches
Date: Sat, 29 Jun 2002 01:21:10 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15644.32486.805715.177514@notabene.cse.unsw.edu.au>
References: <1025113529.1793.8.camel@jason.storix.com>
	<15642.421.825234.16918@notabene.cse.unsw.edu.au>
	<1025114738.1794.19.camel@jason.storix.com>
	<15642.1309.651737.496391@notabene.cse.unsw.edu.au>
	<009b01c21d5e$e68c7050$5701a8c0@bomoon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from bo on Wednesday June 26
To: bo <bo@sosnetwork.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday June 26, bo@sosnetwork.net wrote:
> Neil & Raiders,
> 
> I am using Debian 2.4.5 linux(for ARM ). The "resync" speed is about
> 26M/sec.
> I have 8*120G HDDs so it takes about 24 hours.
> 
> I saw some bug fixes and improvement on this topic from
>  http://marc.theaimsgroup.com/?l=linux-kernel&m=100876771508736&w=2

I don't think any of the patches that you mention are particularly
relevant to your problem.

Maybe if you give some more precise details of your setup??

Also, try
   echo 100000 > /proc/sys/dev/raid/speed_limit_min
does that help?

NeilBrown
