From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Software RAID5 Horrible Write Speed On 3ware Controller!!
Date: Wed, 18 Jul 2007 07:35:15 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0707180734340.7659@p34.internal.lan>
References: <Pine.LNX.4.64.0707180614480.7659@p34.internal.lan>
 <20070718112612.GA8029@cumulus>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070718112612.GA8029@cumulus>
Sender: linux-raid-owner@vger.kernel.org
To: Sander <sander@humilis.net>
Cc: linux-ide-arrays@lists.math.uh.edu, xfs@oss.sgi.com, linux-raid@vger.kernel.org, linux@vger.kernel.org
List-Id: linux-raid.ids



On Wed, 18 Jul 2007, Sander wrote:

> Justin Piszcz wrote (ao):
>> Its too bad that there are no regular > 4 port SATA PCI-e controllers
>> out there.
>
> Is there a disadvantage to using a SaS controller from for example
> lsi.com ?
>
> http://lsi.com/storage_home/products_home/host_bus_adapters/sas_hbas/index.html
>
> I haven't tried them yet, but on paper it looks like an option, no?
>
> 	With kind regards, Sander
>
> -- 
> Humilis IT Services and Solutions
> http://www.humilis.net
>

Hmm that is also a good idea- but I am afraid there could be a similiar 
issue where it tries to do weird caching stuff, even when the drives are 
in JBOD.  Unless they offer a !raid SAS controller that supports SATA 
drives.

Justin.
