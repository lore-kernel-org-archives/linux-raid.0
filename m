From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Write-intent bitmap decreases or increase performance of
 RAID5?
Date: Wed, 30 Jun 2010 07:54:55 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.1006300729150.8623@uplift.swm.pp.se>
References: <20100629201153.GA13018@localhost> <20100630111854.006ec4d0@natsu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100630111854.006ec4d0@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <roman@rm.pp.ru>
Cc: Shaochun Wang <scwang@ios.ac.cn>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 30 Jun 2010, Roman Mamedov wrote:

>  dd if=/dev/zero of=zerofile bs=1M count=2048 conv=fdatasync,notrunc

To be a bit more sure about accurate measurement, make sure the amount of 
data you're transferring is twice the amount of RAM in the machine, the 
above is only 2 gigs of data.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
