From: NeilBrown <neilb@suse.com>
Subject: Re: Problem with XOR Engine
Date: Wed, 12 Aug 2015 07:05:29 +1000
Message-ID: <20150812070529.7764fa15@noble>
References: <22.2C.31182.A9839C55@epcpsbgx2.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22.2C.31182.A9839C55@epcpsbgx2.samsung.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tarak Ramgopal Anumolu <tarak.a@samsung.com>
Cc: linux-raid@vger.kernel.org, sam@bingner.com, hpj@urpla.net
List-Id: linux-raid.ids

On Mon, 10 Aug 2015 23:49:46 +0000 (GMT) Tarak Ramgopal Anumolu
<tarak.a@samsung.com> wrote:

> Samsung Enterprise Portal mySingle
> 
> Hi
> 
>  
> 
> My name is Tarak.
> 
>  
> 
> I got some problem with the XOR engine while creating the RAID array.
> 
>  
> 
> The parity data is getting corrupted and my system is not able to recognize it and some how we are getting the hard disk error.
> 
>  
> 
> I found the above issue is happening when I  enable  CONFIG_RAID_ZERO_COPY=y in my Linux configuration.

My Linux doesn't contain a CONFIG_RAID_ZERO_COPY config option.
Maybe you are using a different Linux.

NeilBrown


> 
>  
> 
> Without this option everything is working fine.
> 
>  
> 
> Following are the version details
> 
> Linux : 3.0.34
> 
> GCC : 4.6.2 (GCC) ) 
> mdadm : v3.2.5
> 
>  
> 
> I want to know the way to fix the RAID parity error.
> 
>  
> 
> Please help me on this.
> 
>  
> 
>  
> 
>  
> 
> Tarak Ramgopal Anumolu 
> 
> Security Solution Division
> 
> SAMSUNG TECHWIN CO.,LTD
> 
> Phone : +82-70-7147-8396
> 
> Mobile: +82-10-7249-8396
> 
> E-mail : tarak.a@samsung.com
> 
>  
> 

