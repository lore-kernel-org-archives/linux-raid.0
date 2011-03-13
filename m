From: Drew <drew.kay@gmail.com>
Subject: Re: Growing a raid array online with different capacity disks
Date: Sun, 13 Mar 2011 06:37:59 -0700
Message-ID: <AANLkTim+iPc-uDQWaNXKGJNbHYaoO8J-9pgi4gF8wXXb@mail.gmail.com>
References: <AANLkTinpcNHZYTnhzv=61e_KAuNHm1j9dp4mQqcKOE_d@mail.gmail.com>
 <alpine.DEB.1.10.1103101356210.7942@uplift.swm.pp.se> <AANLkTikPK+GZp9p1Z6wXio6tAQneQyp_EcE2j+HA2KXo@mail.gmail.com>
 <20110310183650.6a631c13@natsu> <AANLkTi=42cLRctc-3mHokC5FyO55=n6j3si_xm_5y+r1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=42cLRctc-3mHokC5FyO55=n6j3si_xm_5y+r1@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hansbkk@gmail.com
Cc: Roman Mamedov <rm@romanrm.ru>, Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Yes the systems cited by the OP have nothing to do with RAID5, and in
> fact are proprietary - definitely as in "non-standard", and I think
> also none are open source.

QNAP systems are Linux based and the underlying RAID system is based
on mdadm. QNAP uses a newer version of mdadm that supports growing the
array through disk swapping as well as raid level migration.

I spent some time trying to understand how Drobo's "Beyond RAID"
system works and it's nothing special. All they do essentially is
partition the disks and make RAID arrays from within those partitions.
If you had two 500GB disks and two 1TB disks, Drobo would partition
the 1TB drives into 500GB chunks. then RAID the chunks. The first
500GB on all 4 drives would become a RAID-5 and the remaining
partitions on the 1TB drives would become a RAID-1.

Does Drobo use Linux under the hood? No idea. I've shied away from it
because the whole "BeyondRAID" felt kinda hokey.


-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie
