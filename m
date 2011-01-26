From: Oliver Brakmann <obrakmann@gmx.net>
Subject: Re: raid1 mirror optimizations
Date: Wed, 26 Jan 2011 17:37:12 +0100
Message-ID: <g6v518-37d.ln1@oberon.scorpius.lan>
References: <AANLkTimUbWcHi8w6UzxKjkavpOihV7V5Nm58mV7HA0AE@mail.gmail.com>	<tqn318-q0c.ln1@oberon.scorpius.lan> <AANLkTik5rWNd+K8Cji=R3iMGNXjetXUgCbJyPyfD_A9K@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTik5rWNd+K8Cji=R3iMGNXjetXUgCbJyPyfD_A9K@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2011-01-26 16:39, Roberto Spadim wrote:
> i don't know what layout does, but, does raid1 have layout?

No, only raid10 has different layouts.  For an explanation, see David's
mail, or take a look at the Wikipedia entry for non-standard RAID
levels, it illustrates the idea of the different layouts quite well,
IMO: http://en.wikipedia.org/wiki/Non-standard_RAID_levels#Linux_MD_RAID_10


