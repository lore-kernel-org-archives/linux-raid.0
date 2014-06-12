From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: md-raid paranoia mode?
Date: Thu, 12 Jun 2014 16:30:55 +0800
Message-ID: <5399653F.1040503@fnarfbargle.com>
References: <5397FBCE.3060009@bartk.us>	<53990D44.300@fnarfbargle.com>	<20140612122814.2db74377@natsu>	<5399561A.4030405@hesbynett.no> <20140612140644.352e8c69@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140612140644.352e8c69@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>, David Brown <david.brown@hesbynett.no>
Cc: Bart Kus <me@bartk.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 12/06/14 16:06, Roman Mamedov wrote:
> In one case which Brad was describing, it was a hardware design fault 
> in his RAID controller, resulting in it returning bad data only when 
> all ports are utilized at high speeds. If MD had online checksum 
> mismatch detection, it would alert him immediately that something's 
> going wrong, rather than have this bug happily chew through all his 
> data, with "months of read/modify/write cycles combined with corrupt 
> data spread the corruption all over the array".


Yeah, you are right it would have possibly spared some of my data. 
Having said if I'd been paying attention to the mismatch counts at the 
end of my monthly scrubs I'd have noticed it a _lot_ sooner also. I had 
the tools, I was just not using them right. My fault, not md's.

Having said that, if I'd not gone through that I'd probably still not 
have comprehensive and complete backups, and I'd not have 
developed/found tools to allow me to better monitor my systems. So while 
it was a painful experience, it was not catastrophic and (as Calvin's 
dad would say) it built some more character.

I'm a lot older, and hopefully wiser from the experience. I also know my 
time is better spent with monitoring and backups than developing code to 
build that feature into md. While that would paper over one part of the 
storage chain, backups and monitoring covers me end to end.

-- 
Dolphins are so intelligent that within a few weeks they can train 
Americans to stand at the edge of the pool and throw them fish.
