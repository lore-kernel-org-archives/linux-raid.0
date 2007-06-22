From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: limits on raid
Date: Fri, 22 Jun 2007 12:00:51 -0400
Message-ID: <467BF233.7020700@tmr.com>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm> <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm> <18034.3676.477575.490448@notabene.brown> <46756BE2.7010401@tmr.com> <467B03C1.50809@tmr.com> <18043.13037.40956.366334@notabene.brown> <467B840F.4080402@dgreaves.com> <Pine.LNX.4.64.0706220235590.9657@asgard.lang.hm> <467BC306.9010008@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <467BC306.9010008@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: david@lang.hm, Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Greaves wrote:
> david@lang.hm wrote:
>> On Fri, 22 Jun 2007, David Greaves wrote:
>>
>>> That's not a bad thing - until you look at the complexity it brings 
>>> - and then consider the impact and exceptions when you do, eg 
>>> hardware acceleration? md information fed up to the fs layer for 
>>> xfs? simple long term maintenance?
>>>
>>> Often these problems are well worth the benefits of the feature.
>>>
>>> I _wonder_ if this is one where the right thing is to "just say no" :)
>> so for several reasons I don't see this as something that's deserving 
>> of an atomatic 'no'
>>
>> David Lang
>
> Err, re-read it, I hope you'll see that I agree with you - I actually 
> just meant the --assume-clean workaround stuff :)
>
> If you end up 'fiddling' in md because someone specified 
> --assume-clean on a raid5 [in this case just to save a few minutes 
> *testing time* on system with a heavily choked bus!] then that adds 
> *even more* complexity and exception cases into all the stuff you 
> described.

A "few minutes?" Are you reading the times people are seeing with 
multi-TB arrays? Let's see, 5TB at a rebuild rate of 20MB... three days. 
And as soon as you believe that the array is actually "usable" you cut 
that rebuild rate, perhaps in half, and get dog-slow performance from 
the array. It's usable in the sense that reads and writes work, but for 
useful work it's pretty painful. You either fail to understand the 
magnitude of the problem or wish to trivialize it for some reason.

By delaying parity computation until the first write to a stripe only 
the growth of a filesystem is slowed, and all data are protected without 
waiting for the lengthly check. The rebuild speed can be set very low, 
because on-demand rebuild will do most of the work.
>
> I'm very much for the fs layer reading the lower block structure so I 
> don't have to fiddle with arcane tuning parameters - yes, *please* 
> help make xfs self-tuning!
>
> Keeping life as straightforward as possible low down makes the upwards 
> interface more manageable and that goal more realistic... 

Those two paragraphs are mutually exclusive. The fs can be simple 
because it rests on a simple device, even if the "simple device" is 
provided by LVM or md. And LVM and md can stay simple because they rest 
on simple devices, even if they are provided by PATA, SATA, nbd, etc. 
Independent layers make each layer more robust. If you want to 
compromise the layer separation, some approach like ZFS with full 
integration would seem to be promising. Note that layers allow 
specialized features at each point, trading integration for flexibility.

My feeling is that full integration and independent layers each have 
benefits, as you connect the layers to expose operational details you 
need to handle changes in those details, which would seem to make layers 
more complex. What I'm looking for here is better performance in one 
particular layer, the md RAID5 layer. I like to avoid unnecessary 
complexity, but I feel that the current performance suggests room for 
improvement.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

