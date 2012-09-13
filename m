From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: raid5:bad sectors after lost power
Date: Thu, 13 Sep 2012 12:48:10 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1209131245590.13902@uplift.swm.pp.se>
References: <50519cb3.21bf440a.60ca.ffffa83b@mx.google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50519cb3.21bf440a.60ca.ffffa83b@mx.google.com>
Sender: linux-raid-owner@vger.kernel.org
To: vincent <hanguozhong@meganovo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 13 Sep 2012, vincent wrote:

>    These disks were used for the first time after purchased. Is it 
> normal to have bad sectors? Could you please help me?

If a drive gives *write* errors, then it's bad and should be returned.

Read errors might be less weird if you turned off power in the middle of a 
write.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
