From: David Brown <david.brown@hesbynett.no>
Subject: Re: raid1 mirror optimizations
Date: Wed, 26 Jan 2011 22:08:58 +0100
Message-ID: <ihq2ha$q0k$1@dough.gmane.org>
References: <AANLkTimUbWcHi8w6UzxKjkavpOihV7V5Nm58mV7HA0AE@mail.gmail.com>	<tqn318-q0c.ln1@oberon.scorpius.lan> <AANLkTik5rWNd+K8Cji=R3iMGNXjetXUgCbJyPyfD_A9K@mail.gmail.com> <g6v518-37d.ln1@oberon.scorpius.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <g6v518-37d.ln1@oberon.scorpius.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 26/01/11 17:37, Oliver Brakmann wrote:
> On 2011-01-26 16:39, Roberto Spadim wrote:
>> i don't know what layout does, but, does raid1 have layout?
>
> No, only raid10 has different layouts.  For an explanation, see David's
> mail, or take a look at the Wikipedia entry for non-standard RAID
> levels, it illustrates the idea of the different layouts quite well,
> IMO: http://en.wikipedia.org/wiki/Non-standard_RAID_levels#Linux_MD_RAID_10
>

There are also different layouts for raid5 and raid6, though I don't 
think they make much difference unless you are doing something odd like 
trying to make your mdadm raid5/6 layout exactly match that of some 
hardware raid controller.  There are also special layouts that are used 
as intermediary steps in converting between raid5 and raid6 - you won't 
want to touch these.

So raid10 is the only level with /useful/ layout options.  The different 
options can make a measurable speed difference, with the best choice 
depending on the load.  The "far 2" layout is, I think, the best choice 
for common ready-heavy loads.


