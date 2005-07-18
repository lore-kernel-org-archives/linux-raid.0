From: Jim Radford <jradford@npl.com>
Subject: Re: md_import_device returned -16 raid1
Date: Mon, 18 Jul 2005 15:12:07 -0700 (PDT)
Message-ID: <Pine.LNX.4.61.0507181510580.8523@hoss.npl.com>
References: <Pine.LNX.4.61.0507161534210.8523@hoss.npl.com>
 <17113.37737.512268.68189@cse.unsw.edu.au> <Pine.LNX.4.61.0507161611050.8523@hoss.npl.com>
 <Pine.LNX.4.61.0507161630330.8523@hoss.npl.com> <20050718155706.GF31959@percy.comedia.it>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050718155706.GF31959@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 18 Jul 2005, Luca Berra wrote:

> On Sat, Jul 16, 2005 at 04:32:05PM -0700, Jim Radford wrote:
>> lvm2 seems to be the cause, I removed all lv/vg/pv's and it started fine. 
>> My guess is I need to change something in the mandrake initscripts (order 
>> wise) to make sure lvm doesn't kick into gear until the raid has started.
>> 
> check you have 
> md_component_detection = 1
>
> in /etc/lvm/lvm.conf, it should be the default.

That is the default, however the way Mandrake does their initscript I had 
to move the LVM stuff until after the raid is started to make it work 
right. It is working great now.

Jim

-- 
==========================================================================
Jim Radford <jradford@npl.com>
http://www.jimradford.com/
==========================================================================
