From: Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>
Subject: Re: Problem with XOR Engine
Date: Tue, 11 Aug 2015 08:29:53 +0200
Message-ID: <55C99661.20901@aei.mpg.de>
References: <loom.20150811T081553-897@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20150811T081553-897@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tarak Anumolu <tarak.a@samsung.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Tarak

On 11.08.2015 08:16, Tarak Anumolu wrote:
> I got some problem with the XOR engine while creating the RAID array.
> 

I doubt that you will get much (more) attention if you continue to spam
the list, also with people distributed around the world, expecting a
solid reply within less than 8 hours is at least a bit questionable,
don't you think so?

> The parity data is getting corrupted and my system is not able to recognize 
> it and some how we are getting the hard disk error.
> 
> I found the above issue is happening when I  enable  
> CONFIG_RAID_ZERO_COPY=y in my Linux configuration.
> 
> Without this option everything is working fine.
> 

I think (I'm only a user myself and no developer), without much more
extra information, it will be hard to help, i.e. more information what
kern.log/dmesg shows in both situations, /proc/mdstat output, mdadm
examine, ....

Cheers

Carsten
