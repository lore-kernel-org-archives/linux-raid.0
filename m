From: David Greaves <david@dgreaves.com>
Subject: Re: limits on raid
Date: Fri, 22 Jun 2007 17:55:46 +0100
Message-ID: <467BFF12.60200@dgreaves.com>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm> <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm> <18034.3676.477575.490448@notabene.brown> <46756BE2.7010401@tmr.com> <467B03C1.50809@tmr.com> <18043.13037.40956.366334@notabene.brown> <467B840F.4080402@dgreaves.com> <Pine.LNX.4.64.0706220235590.9657@asgard.lang.hm> <467BC306.9010008@dgreaves.com> <467BF233.7020700@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <467BF233.7020700@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: david@lang.hm, Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen wrote:
> David Greaves wrote:
>> david@lang.hm wrote:
>>> On Fri, 22 Jun 2007, David Greaves wrote:
>> If you end up 'fiddling' in md because someone specified 
>> --assume-clean on a raid5 [in this case just to save a few minutes 
>> *testing time* on system with a heavily choked bus!] then that adds 
>> *even more* complexity and exception cases into all the stuff you 
>> described.
> 
> A "few minutes?" Are you reading the times people are seeing with 
> multi-TB arrays? Let's see, 5TB at a rebuild rate of 20MB... three days. 
Yes. But we are talking initial creation here.

> And as soon as you believe that the array is actually "usable" you cut 
> that rebuild rate, perhaps in half, and get dog-slow performance from 
> the array. It's usable in the sense that reads and writes work, but for 
> useful work it's pretty painful. You either fail to understand the 
> magnitude of the problem or wish to trivialize it for some reason.
I do understand the problem and I'm not trying to trivialise it :)

I _suggested_ that it's worth thinking about things rather than jumping in to 
say "oh, we can code up a clever algorithm that keeps track of what stripes have 
valid parity and which don't and we can optimise the read/copy/write for valid 
stripes and use the raid6 type read-all/write-all for invalid stripes and then 
we can write a bit extra on the check code to set the bitmaps......"

Phew - and that lets us run the array at semi-degraded performance (raid6-like) 
for 3 days rather than either waiting before we put it into production or 
running it very slowly.
Now we run this system for 3 years and we saved 3 days - hmmm IS IT WORTH IT?

What happens in those 3 years when we have a disk fail? The solution doesn't 
apply then - it's 3 days to rebuild - like it or not.

> By delaying parity computation until the first write to a stripe only 
> the growth of a filesystem is slowed, and all data are protected without 
> waiting for the lengthly check. The rebuild speed can be set very low, 
> because on-demand rebuild will do most of the work.
I am not saying you are wrong.
I ask merely if the balance of benefit outweighs the balance of complexity.

If the benefit were 24x7 then sure - eg using hardware assist in the raid calcs 
- very useful indeed.

>> I'm very much for the fs layer reading the lower block structure so I 
>> don't have to fiddle with arcane tuning parameters - yes, *please* 
>> help make xfs self-tuning!
>>
>> Keeping life as straightforward as possible low down makes the upwards 
>> interface more manageable and that goal more realistic... 
> 
> Those two paragraphs are mutually exclusive. The fs can be simple 
> because it rests on a simple device, even if the "simple device" is 
> provided by LVM or md. And LVM and md can stay simple because they rest 
> on simple devices, even if they are provided by PATA, SATA, nbd, etc. 
> Independent layers make each layer more robust. If you want to 
> compromise the layer separation, some approach like ZFS with full 
> integration would seem to be promising. Note that layers allow 
> specialized features at each point, trading integration for flexibility.

That's a simplistic summary.
You *can* loosely couple the layers. But you can enrich the interface and 
tightly couple them too - XFS is capable (I guess) of understanding md more 
fully than say ext2.
XFS would still work on a less 'talkative' block device where performance wasn't 
as important (USB flash maybe, dunno).


> My feeling is that full integration and independent layers each have 
> benefits, as you connect the layers to expose operational details you 
> need to handle changes in those details, which would seem to make layers 
> more complex.
Agreed.

> What I'm looking for here is better performance in one 
> particular layer, the md RAID5 layer. I like to avoid unnecessary 
> complexity, but I feel that the current performance suggests room for 
> improvement.

I agree there is room for improvement.
I suggest that it may be more fruitful to write a tool called "raid5prepare"
that writes zeroes/ones as appropriate to all component devices and then you can 
use --assume-clean without concern. That could look to see if the devices are 
scsi or whatever and take advantage of the hyperfast block writes that can be done.

David
