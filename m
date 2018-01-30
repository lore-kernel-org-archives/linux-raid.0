From: Wol's lists <antlists@youngman.org.uk>
Subject: Re: [LSF/MM TOPIC] De-clustered RAID with MD
Date: Tue, 30 Jan 2018 17:40:02 +0000
Message-ID: <337d2541-e8d1-1c2e-e61b-bcca1e7c7388@youngman.org.uk>
References: <mqdvafkhep0.fsf@linux-x5ow.site>
 <5A6F4CA6.5060802@youngman.org.uk> <87fu6o5o83.fsf@notabene.neil.brown.name>
 <5A704C59.4000705@youngman.org.uk> <87372n613s.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87372n613s.fsf@notabene.neil.brown.name>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, lsf-pc@lists.linux-foundation.org
Cc: linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On 30/01/18 11:24, NeilBrown wrote:
> On Tue, Jan 30 2018, Wols Lists wrote:
> 
>> On 29/01/18 21:50, NeilBrown wrote:
>>> By doing declustered parity you can sanely do raid6 on 100 drives, using
>>> a logical stripe size that is much smaller than 100.
>>> When recovering a single drive, the 10-groups-of-10 would put heavy load
>>> on 9 other drives, while the decluster approach puts light load on 99
>>> other drives.  No matter how clever md is at throttling recovery, I
>>> would still rather distribute the load so that md has an easier job.
>>
>> Not offering to do it ... :-)
>>
>> But that sounds a bit like linux raid-10. Could a simple approach be to
>> do something like "raid-6,11,100", ie raid-6 with 9 data chunks, two
>> parity, striped across 100 drives? Okay, it's not as good as the
>> decluster approach, but it would spread the stress of a rebuild across
>> 20 drives, not 10. And probably be fairly easy to implement.
> 
> If you did that, I think you would be about 80% of the way to fully
> declustered-parity RAID.
> If you then tweak the math a bit so that one stripe would was
> 
> A1 A2 A3 A4 B1 B2 B3 B4 C1 C2 C3 C4 ....
> 
> and the next
> 
> A1 C1 A2 C2 A3 C3 A4 C4 B1 D1 B2 D2 ....
> 
> and then
> 
> A1 B1 C1 D1 A2 B2 C2 D2 A3 B3 C3 D3 ....
> 
>                    XX
>                    
> When Ax are a logical stripe and Bx are the next,  then you have a
> slightly better distribution.  If device XX fails then the reads needed
> for the first stripe mostly come from different drives than those for
> the second stripe, which are mostly different again for the 3rd stripe.
> 
> Presumably the CRUSH algorithm (which I only skim-read once about a year
> ago) formalizes how to do this, and does it better.
> Once you have the data handling in place for your proposal, it should be
> little more than replacing a couple of calculations to get the full
> solution.
> 
Okay. I think I have it - a definition for raid-16 (or is it raid-61). 
But I need a bit of help with the maths. And it might need a look-up 
table :-(

Okay. Like raid-10, raid-16 would be spec'd as "--level 16,3,8", ie 3 
mirrors, emulating an 8-drive raid-6.

What I'm looking for is a PRNG that has the "bug" that it repeats over a 
short period, and over that period is guaranteed to repeat each number 
the same number of times. I saw a wonderful video demonstration of this 
years ago - if you plot the generated number against the number of times 
it was generated, after a few rows it "filled up" a rectangle on the graph.

At which point the maths becomes very simple. I just need at least as 
many real drives as "mirrors times emulated".

If somebody can come up with the algorithm I want, I can spec it, and 
then maybe someone can implement it? It'll be fun testing - I'll need my 
new machine when I get it working :-)

Cheers,
Wol
