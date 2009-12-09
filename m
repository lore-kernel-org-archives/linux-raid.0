From: Artur Wojcik <artur.wojcik@intel.com>
Subject: Re: [patch 0/1][mdadm] Fix needed to enable RAID volumes on SAS
 devices (version 2).
Date: Wed, 9 Dec 2009 18:41:51 +0100
Message-ID: <1260380511.27877.25.camel@awojcik-linux>
References: <58C655507FA1494D95397652C4416F35CCF61201@irsmsx503.ger.corp.intel.com>
	 <20091113193545.GW21495@skl-net.de>
	 <1259593933.3178.122.camel@awojcik-linux>
	 <20091208163744.7ea0eef9@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091208163744.7ea0eef9@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Andre Noll <maan@systemlinux.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Neil,
The patch version 3 is actually bare minimum but it relay does the
trick. I think it is what I suppose to sent to you at first. Please
forgive my mistakes, but I'm just learning how to cooperate 
with the community.

> And I don't like the introduction of a new header file just to store one or 2
> definitions.  Just put new definitions in mdadm.h  Keep It Simple.

Sorry but I don't agree. At the moment the source code of mdadm/mdmon is
not simple. It's quite complicated. It is hard to analyze how the
control flows and there's a lot of data and code redundancy in it. In my
opinion "refactorization" is what this code needs. Splitting code into
files would be helpful, too.

> I am perfectly happy with making 'buf' larger as appropriate, even making it
> PATH_MAX in some cases.
> I would be happy with more use of asprinf.
> I would be happy adding checks before certain critical sprintf calls that
> the result will not exceed the buffer.

I did not use asprintf function, because it's GNU specific. I had an
impression that one may try to build mdmdm using non-GNU toolchain.
---
Artur




