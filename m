From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Adding a smaller drive
Date: Mon, 29 Jun 2009 02:02:21 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.0906290158190.5467@uplift.swm.pp.se>
References: <20090628194705152.ITZI24524@cdptpa-omta02.mail.rr.com> <yq1eit411s4.fsf@sermon.lab.mkp.net> <alpine.DEB.1.10.0906290029410.5467@uplift.swm.pp.se> <4A4802D1.4080305@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A4802D1.4080305@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 29 Jun 2009, John Robinson wrote:

> On 28/06/2009 23:33, Mikael Abrahamsson wrote:
>> (2TB ones have 3907029168 sectors, the 1TB ones have 1953103872).
>
> Those 1TB ones are under 1TB: they have 999989182464 bytes.

If I use smartctl instead of using fdisk after 3ware superblock, it says:

Device Model:     WDC WD10EACS-00ZJB0
User Capacity:    1,000,204,886,016 bytes

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
