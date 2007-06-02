From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: RAID 6 grow problem
Date: Sat, 2 Jun 2007 17:33:55 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0706021733500.22603@p34.internal.lan>
References: <C2879F21.7ED1%groups@email.iain.rauch.co.uk>
 <Pine.LNX.4.64.0706021731360.22567@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706021731360.22567@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Iain Rauch <groups@email.iain.rauch.co.uk>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

CONFIG_MD_RAID5_RESHAPE=y

Check for this option.

On Sat, 2 Jun 2007, Justin Piszcz wrote:

>
>
> On Sat, 2 Jun 2007, Iain Rauch wrote:
>
>>> For the critical section part, it may be your syntax..
>>> 
>>> When I had the problem, Neil showed me the path! :)
>> I don't think it is incorrect, before I thought it was supposted to specify
>> an actual file so I 'touch'ed one and it says file exists.
>> 
>>> For your issue, do you have raid5/6 GROW support enabled in the kernel?
>>> Also I grew mine I never used the --backup-file option.
>> I don't know, how would I find this out? uname -r gives me 
>> 2.6.20-15-server.
>> 
>> 
>> Iain
>> 
>> 
>
> Find the .config for your kernel and see if the raid5 grow support is 
> enabled.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
