From: david@lang.hm
Subject: Re: limits on raid
Date: Fri, 22 Jun 2007 11:41:49 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0706221137200.14942@asgard.lang.hm>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>
 <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>
 <18034.3676.477575.490448@notabene.brown> <46756BE2.7010401@tmr.com>
 <467B03C1.50809@tmr.com> <18043.13037.40956.366334@notabene.brown>
 <467B840F.4080402@dgreaves.com> <Pine.LNX.4.64.0706220235590.9657@asgard.lang.hm>
 <467BC306.9010008@dgreaves.com> <467BF233.7020700@tmr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <467BF233.7020700@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: David Greaves <david@dgreaves.com>, Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 22 Jun 2007, Bill Davidsen wrote:

> By delaying parity computation until the first write to a stripe only the 
> growth of a filesystem is slowed, and all data are protected without waiting 
> for the lengthly check. The rebuild speed can be set very low, because 
> on-demand rebuild will do most of the work.
>>
>>  I'm very much for the fs layer reading the lower block structure so I
>>  don't have to fiddle with arcane tuning parameters - yes, *please* help
>>  make xfs self-tuning!
>>
>>  Keeping life as straightforward as possible low down makes the upwards
>>  interface more manageable and that goal more realistic... 
>
> Those two paragraphs are mutually exclusive. The fs can be simple because it 
> rests on a simple device, even if the "simple device" is provided by LVM or 
> md. And LVM and md can stay simple because they rest on simple devices, even 
> if they are provided by PATA, SATA, nbd, etc. Independent layers make each 
> layer more robust. If you want to compromise the layer separation, some 
> approach like ZFS with full integration would seem to be promising. Note that 
> layers allow specialized features at each point, trading integration for 
> flexibility.
>
> My feeling is that full integration and independent layers each have 
> benefits, as you connect the layers to expose operational details you need to 
> handle changes in those details, which would seem to make layers more 
> complex. What I'm looking for here is better performance in one particular 
> layer, the md RAID5 layer. I like to avoid unnecessary complexity, but I feel 
> that the current performance suggests room for improvement.

they both have have benifits, but it shouldn't have to be either-or

if you build the seperate layers and provide for ways that the upper 
layers can query the lower layers to find what's efficiant then you can 
have some uppoer layers that don't care about this and trat the lower 
layer as a simple block device, while other upper layers find out what 
sort of things are more efficiant to do and use the same lower layer in a 
more complex manner

the alturnative is to duplicate effort (and code) to have two codebases 
that try to do the same thing, one stand-alone, and one as a part of an 
integrated solution (and it gets even worse if there end up being multiple 
integrated solutions)

David Lang
