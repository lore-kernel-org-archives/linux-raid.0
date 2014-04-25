From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Why would a recreation cause a different number of blocks??
Date: Fri, 25 Apr 2014 08:01:27 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1404250800190.19744@uplift.swm.pp.se>
References: <20140424070548.445497dd@netstation> <20140424194832.2d0a867f@netstation> <CAK_KU4a+Ep7=F=NSbb-hqN6Rvayx4QPWm-M2403OHn5-LVaNZw@mail.gmail.com> <20140424203506.5fdee0d3@netstation> <CAK_KU4Zh-azXEEzW4f1m=boCZDKevqaSHxW0XoAgRdrCbm2PkA@mail.gmail
 <53598F69.5070700@csun.edu> <alpine.DEB.2.02.1404250533040.19744@uplift.swm.pp.se> <5359EC4D.7000308@csun.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5359EC4D.7000308@csun.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Wiegley <jeffw@csun.edu>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 24 Apr 2014, Jeff Wiegley wrote:

> If it's mdadm then could I just grab old copies of mdadm sources and 
> compile them one version after the other and try each one?

As far as I know, it's mdadm version specific. If you look in the archives 
I'm sure you'll be able to find the old offsets and you can use the latest 
mdadm with those offsets and hopefully things will work.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
