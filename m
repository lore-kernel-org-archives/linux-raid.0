From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: raind-1 resync speed slow down to 50% by the time it finishes
Date: Thu, 30 Jul 2009 10:44:21 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.0907301042140.5086@uplift.swm.pp.se>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C07C7D7D6@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AC5E1C3367E37D44970B81A6ADD1DA2C07C7D7D6@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tirumala Reddy Marri <tmarri@amcc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 29 Jul 2009, Tirumala Reddy Marri wrote:

> Hi,
>  I have two 1 tera byte disks in RAID-1 configuration. When I started
> RAID-1 array initial speed was 100MBps by the time it finishes the speed
> was <50MBps. Is there is any reason for this behavior ? Isn't speed
> supposedly uniform.

No, as the reading heads reaches the inner part of the discs, transfer 
speed goes down.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
