From: "michael" <michael@estone.ca>
Subject: Re: How to start SW raid later in boot?
Date: Thu, 5 Feb 2009 03:23:39 -0800
Message-ID: <20090205112014.M278@estone.ca>
References: <20090204193039.M36676@estone.ca> <498A0D0E.70000@musmo.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <498A0D0E.70000@musmo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linuxraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 04 Feb 2009 22:47:58 +0100, KwangErn Liew wrote

> 
> Do you have initrd enabled?
> 

I believe I do, its a standard install of Debian stable.
For now, I suppose I can do as the last poster suggested and 
run a startup script to assemble the array, and mount it.

I will look more into the driver as its a 3rd party loaded module.
Perhaps it can be setup to load earlier in the boot.

Thanks,
Mike 
