From: Roberto Spadim <rspadim@gmail.com>
Subject: Re: Multiple SSDs - RAID-1, -10, or stacked? TRIM?
Date: Wed, 9 Oct 2013 15:04:17 -0300
Message-ID: <CAH3kUhGo2Agof7tcE_+jJCQx6njXekyuVmLqTB9oCKyc2RGPYg@mail.gmail.com>
References: <20131009123135.GT1779@bitfolk.com>
	<l33q8a$da4$1@ger.gmane.org>
	<5255827B.8090309@hesbynett.no>
	<l3440m$85s$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <l3440m$85s$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Is it potentially even more important when using SSDs, though?  I
> believe that the answer is yes.
>
> I guess we just have to wait for Google to migrate their entire
> infrastructure for SSDs and publish a new study ...


maybe not... facebook use ssd as cache for hdd check flashcache -
https://github.com/facebook/flashcache/ it's a high write/read
workload, maybe ssd+hdd is better

-- 
Roberto Spadim
