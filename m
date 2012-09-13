From: David Brown <david.brown@hesbynett.no>
Subject: Re: make filesystem failed while the capacity of raid5 is big than
 16TB
Date: Thu, 13 Sep 2012 15:52:21 +0200
Message-ID: <5051E515.4030106@hesbynett.no>
References: <505033fe.8aec440a.5d52.ffffe37b@mx.google.com> <50504094.2040302@hesbynett.no> <CACY-59cLmV2SRY+FrvhHxseDD1+r-B-3bOKPGzJdGttW+9U2mw@mail.gmail.com> <505059DD.8000108@hesbynett.no> <CACY-59dAbS=8ncRAeZrAYBAvo7G6FEyoGREHtC-ze4cwhiF9GQ@mail.gmail.com> <5051DEC3.9050703@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5051DEC3.9050703@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: GuoZhong Han <hanguozhong@meganovo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 13/09/2012 15:25, Stan Hoeppner wrote:
> On 9/12/2012 10:21 PM, GuoZhong Han wrote:
>
>>           This system has a 36 cores CPU, the frequency of each core is
>> 1.2G.
>
> Obviously not an x86 CPU.  36 cores.  Must be a Tilera chip.
>

I don't know of any other 36-core chips - but the OP would have to 
answer that.

> GuoZhong, be aware that high core count systems are a poor match for
> Linux md/RAID levels 1/5/6/10.  These md/RAID drivers currently utilize
> a single write thread, and thus can only use one CPU core at a time.
>

Even with multitheaded raid support, such high core-count chips are not 
ideal for this sort of application.

> To begin to sufficiently scale these md array types across 36x 1.2GHz
> cores you would need something like the following configurations, all
> striped together or concatenated with md or LVM:
>
> 72x md/RAID1 mirror pairs
>   36x 4 disk RAID10 arrays
>   36x 4 disk RAID6 ararys
>   36x 3 disk RAID5 arrays
>
> Patches are currently being developed to increase the parallelism of
> RAID1/5/6/10 but will likely not be ready for production kernels for
> some time.   These patches will however still not allow scaling an
> md/RAID driver across such a high core count.  You'll still need
> multiple arrays to take advantage of 36 cores.  Thus, this 16 drive
> storage appliance would have much better performance with a single/dual
> core CPU with a 2-3GHz clock speed.
>

I doubt if the OP is aiming to saturate all 36 cores.  There is no need 
to scale across all the cores - the aim is just to spread the load 
amongst enough cores that processing power is not a bottleneck.  If you 
can achieve this with four cores in use and 32 cores sitting idle, then 
that is just as good as running 36 cores at 10% capacity.

But I absolutely agree that it is a lot easier to achieve the required 
performance with a few fast cores than lots of slower cores.

The other issue to consider here is IO and memory bandwidths - high core 
count chips don't have the bandwidth to fully utilise the cores on 
storage applications.

> If I were doing such a product, I'd immediately toss out the 36 core
> logic platform and switch to a low power single/dual core x86 chip.

I'd go for at least two, but probably four cores - the difference in 
price is going to be irrelevant compared to the rest of the hardware. 
But I agree that large numbers of cores are probably wasted.

The only reason I would want lots of cores here is if the device is more 
than just a storage array.  For example, if you are compressing or 
encrypting the data, or using encryption on the network connections, 
then extra cores will be useful.

