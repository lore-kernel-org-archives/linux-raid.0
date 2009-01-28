From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: SSD data reliable vs. unreliable [Was: Re: Data Recovery from
 	SSDs - Impact of trim?]
Date: Wed, 28 Jan 2009 15:11:19 -0500
Message-ID: <4980BBE7.30808@tmr.com>
References: <87f94c370901221553p4d3a749fl4717deabba5419ec@mail.gmail.com>	<497A2B3C.3060603@redhat.com>	<1232749447.3250.146.camel@localhost.localdomain>	<87f94c370901231526jb41ea66ta1d6a23d7631d63c@mail.gmail.com>	<497A542C.1040900@redhat.com>	<7fce22690901260659u30ffd634m3fb7f75102141ee9@mail.gmail.com>	<497DE35C.6090308@redhat.com>	<87f94c370901260934vef69a2cgada9ae3dfdb440ef@mail.gmail.com>	<1232992065.3248.38.camel@localhost.localdomain> <18814.39074.194781.490676@notabene.brown> <497EE6A4.7030406@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <497EE6A4.7030406@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Neil Brown <neilb@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Greg Freemyer <greg.freemyer@norcrossgroup.com>, Ric Wheeler <rwheeler@redhat.com>, linux-raid <linux-raid@vger.kernel.org>, Dongjun Shin <djshin90@gmail.com>, IDE/ATA development list <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

John Robinson wrote:
> On 27/01/2009 05:16, Neil Brown wrote:
> [...]
>> Probably the only practical data structure for this would be a bitmap
>> similar to the current write-intent bitmap.
>>
>> Is it really worth supporting this in raid5?   Are the sorts of
>> devices that will benefit from 'discard' requests likely to be used
>> inside an md/raid5 array I wonder....
>
> Assuming I've understood correctly, this usage map sounds to me like a 
> useful thing to have for all RAIDs. When building the array in the 
> first place, the initial sync is just writing a usage map saying it's 
> all empty. Filesystem writes and discards update it appropriately. 
> Then when we get failing sectors reported via e.g. SMART or a scrub 
> operation we know whether they're on used or unused areas so whether 
> it's worth attempting recovery.

It would seem that this could really speed initialization. A per-stripe 
"unused" bitmap could save a lot of time in init, but also in the check 
operation on partially used media. It's not just being nice to SDD, but 
being nice to power consumption, performance impact, rebuild time... 
other than the initial coding and testing required, I can't see any 
downside to this.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


