From: Jonathan <jrs@abhost.net>
Subject: Re: data recovery on raid5
Date: Sat, 22 Apr 2006 13:07:32 -0700
Message-ID: <444A8D04.20809@abhost.net>
References: <444A7C99.80006@abhost.net> <62b0912f0604221248s653843bfx363f346c7ef31a94@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62b0912f0604221248s653843bfx363f346c7ef31a94@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I was already terrified of screwing things up -- now I'm afraid of 
making things worse

based on what was posted before is this a sensible thing to try?

mdadm -C /dev/md0 -c 32 -n 4 -l 5 missing /dev/etherd/e0.[023]

Is what I've done to the superblock size recoverable?

I don't understand how mdadm --assemble would know what to do, which is 
why I didn't try it initially.  That said, obviouly my lack of 
understanding isn't helping one bit.

I don't think I can afford a penny per byte, but I'd happy part with 
hundreds of dollars to get the data back.  I would really like someone 
with more knowledge than me to hold my hand before I continue to make 
things worse.

help please - support@abhost.net

-- Jonathan


Molle Bestefich wrote:

>Jonathan wrote:
>  
>
>># mdadm -C /dev/md0 -n 4 -l 5 missing /dev/etherd/e0.[023]
>>    
>>
>
>I think you should have tried "mdadm --assemble --force" first, as I
>proposed earlier.
>
>By doing the above, you have effectively replaced your version 0.9.0
>superblocks with version 0.9.2.  I don't know if version 0.9.2
>superblocks are larger than 0.9.0, Neil hasn't responded to that yet. 
>Potentially hazardous, who knows.
>
>Anyway.
>This is from your old superblock as described by Sam Hopkins:
>
>  
>
>>/dev/etherd/<blah>:
>>     Chunk Size : 32K
>>    
>>
>
>This is from what you've just posted:
>  
>
>>/dev/etherd/<blah>:
>>     Chunk Size : 64K
>>    
>>
>
>If I were you, I'd recreate your superblocks now, but with the correct
>chunk size (use -c).
>
>  
>
>>We'll be happy to pay you for your services.
>>    
>>
>
>I'll be modest and charge you a penny per byte of data recovered, ho hum.
>  
>

