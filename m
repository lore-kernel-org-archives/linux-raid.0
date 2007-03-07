From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: mismatch_cnt questions
Date: Tue, 06 Mar 2007 19:22:37 -0500
Message-ID: <45EE05CD.7080007@tmr.com>
References: <bb145bd20703040322g1e5e8784i93a933c0c61b43f6@mail.gmail.com>	<17898.45673.573800.56474@notabene.brown>	<45EB3867.8050907@eyal.emu.id.au>	<17899.18568.523543.478792@notabene.brown>	<45EBCA83.40106@eyal.emu.id.au> <17900.43653.510415.553440@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17900.43653.510415.553440@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Eyal Lebedinsky <eyal@eyal.emu.id.au>, Christian Pernegger <pernegger@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Monday March 5, eyal@eyal.emu.id.au wrote:
>   
>> Neil Brown wrote:
>> [trim Q re how resync fixes data]
>>     
>>> For raid1 we 'fix' and inconsistency by arbitrarily choosing one copy
>>> and writing it over all other copies.
>>> For raid5 we assume the data is correct and update the parity.
>>>       
>> Can raid6 identify the bad block (two parity blocks could allow this
>> if only one block has bad data in a stripe)? If so, does it?
>>     
>
> No, it doesn't.
>
> I guess that maybe it could:
>    Rebuild each block in turn based on the xor parity, and then test 
>    if the Q-syndrome is satisfied.
> but I doubt the gain would be worth the pain.
What's the value of "I have a drive which returned bad data" vs. "I have 
a whole array and some part of it returned bad data?" What's the cost of 
doing that identification, since it need only be done when the data are 
inconsistent between the drives and give a parity or Q mismatch? It 
seems easy, given that you are going to read all the pertinent sectors 
into memory anyway.

If the drive can be identified the data can be rewritten with confidence.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

