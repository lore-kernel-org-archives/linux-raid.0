From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: RAID10 Performance
Date: Wed, 8 Aug 2012 14:14:12 -0300
Message-ID: <CABYL=Tr0VhAX1uMPFbnWo=7cgsG3xsqQA+o==jp5FyonX419_g@mail.gmail.com>
References: <50115123.1020900@websitemanagers.com.au>
	<50123E2C.8090108@hardwarefreak.com>
	<50129176.3050604@websitemanagers.com.au>
	<5012DE22.10108@hardwarefreak.com>
	<50138853.5030100@websitemanagers.com.au>
	<50140657.8010802@hardwarefreak.com>
	<5021E1BC.3060607@websitemanagers.com.au>
	<50229B0D.5070201@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50229B0D.5070201@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Adam Goryachev <mailinglists@websitemanagers.com.au>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> md/RAID1 doesn't guarantee symmetric read IO across members of the pair.
>  RAID1 isn't for high performance.  It's for cheap redundancy.  Even
> RAID0 can exhibit this behavior if you have a large chunk size and lots
> of small files.  They tend to align to the first drive in the stripe
> because they fit entirely within the chunk.  This is why a default 512KB
> chunk is insane for most workloads, especially mail servers.

raid1 is very very good for parallel read (many threads reading different files)
in my tests a high load database server runs better in raid1 than
raid10 when it need server many clients in small queries instead big
queries and low users (here raid10 runs better)
i'm using harddisk not ssd

some news in raid1 read algorithm are promissing and i think we will
have betters numbers in tests...


-- 
Roberto Spadim
Spadim Technology / SPAEmpresarial
