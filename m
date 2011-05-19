From: Ed W <lists@wildgooses.com>
Subject: HBA Adaptor advice
Date: Thu, 19 May 2011 13:26:49 +0100
Message-ID: <4DD50C89.8060006@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, following on from a recent thread, can folks with decent multi-port
HBA adaptors please chime in with some model numbers of known decent
adaptors please?

The required use is to grow from currently 8 ish drives to perhaps 12-2=
4
drives per machine. (It partitions out as: one or more RAID6 arrays for
data, plus a couple of backup drives)

Ideally I would like a controller with writeback cache and BBU since
whilst this office machine is likely quite underused, for any sensible
amount of IO (some of the other machines we might upgrade) this seems t=
o
give a 10-100x increase in IOPs?  For the moment it's just a nice to
have though

I only intend to use linux software raid, so any onboard raid
functionality is just a liability.  Budget is either low =A3100 ish for
multi-port HBAs without cache, up to =A31000 ish for 16-24 port high
performance cache controllers:


So far I saw recommendations for:

- LSI 1068E (SuperMicro 3081E)  (8 port 3Gb)
- LSI 9211-8i (8 port 6Gb)

And to avoid:
- Marvel controllers?
- Areca with marvel controllers?
- AOC-SASLP-MV8

these any good?
- LSI MegaRAID 9280-24i4e
- Areca ARC-1880ix-24


I'm completely ignorant of the current state of adaptors today:

- Are there any bargains to be had in the lower end 8-24 port category
(ie come up frequently as ebay specials and aren't locked to special
DELL-only disks, etc?)

- Cable management. Are there any backplanes for retro fitting into
desktop chassis (5 1/4 bays say?) which take single (8087?) connectors?


At the moment I just need to refresh our office server (10-12 disks
including back drives) and we need something compact and quiet so
looking for compact tower chassis options.  I'm also looking at adding
more storage into our datacenter racks though, so interested in a
shopping list of reliable higher performance options?

Please add suggestions for good value, reliable controllers known to
work well with linux

Thanks

Ed W

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
