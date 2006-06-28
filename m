From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Ok to go ahead with this setup?
Date: Wed, 28 Jun 2006 10:45:01 +0400
Message-ID: <44A2256D.7070604@wasp.net.au>
References: <bb145bd20606221008p131d4daem289a6b9300757c66@mail.gmail.com> 	 <62b0912f0606221104q2f47f574i86441efed5831957@mail.gmail.com> 	 <bb145bd20606221250y147d0a0bk1e371a3078adc09e@mail.gmail.com>	 <62b0912f0606221511p74a78ca5id4b5d3f870258815@mail.gmail.com> <Pine.LNX.4.64.0606272241040.26384@router.windsormachine.com> <44A2204D.D21130B7@ardistech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44A2204D.D21130B7@ardistech.com>
Sender: linux-raid-owner@vger.kernel.org
To: bart@ardistech.com
Cc: Mike Dresser <mdresser_l@windsormachine.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

bart@ardistech.com wrote:
> Mike Dresser wrote:
>> On Fri, 23 Jun 2006, Molle Bestefich wrote:
>>
>>> Christian Pernegger wrote:
>>>> Anything specific wrong with the Maxtors?
>>> I'd watch out regarding the Western Digital disks, apparently they
>>> have a bad habit of turning themselves off when used in RAID mode, for
>>> some reason:
>>> http://thread.gmane.org/gmane.linux.kernel.device-mapper.devel/1980/
>> The MaxLine III's (7V300F0) with VA111630/670 firmware currently timeout
>> on a weekly or less basis.. I'm still testing VA111680 on a 15x300 gig
>> array
>>
> We also see similar problem on Maxtor 6V250F0 drives: they 'crash' randomly at
> a weeks timescale. Only way to get them back is by power cycling. Tried both
> SuperMicro SATA card (Marvell chip) and Promise Fastrak, firmware updates from
> Maxtor did not fix it yet. We were already forced to exchange all drives at
> a customer because he does not want to use Maxtor's anymore. Neither do we :(


Whereas I have 28 7Y250M0 drives sitting in a couple of arrays here that have behaved perfectly 
(aside from some grown defects) for over 18000 hours so far. They are *all* sitting on Promise 
SATA150TX4 cards on 2.6 kernels.

I'm looking at another server and another 15 drives at the moment, and it's Maxtors I'm looking at.

Everyone has different experience. I would not touch Seagate with a 10 foot pole (blew up way too 
many logic boards when I was using them), and I got bitten *badly* by the WD firmware issue with 
RAID (firmware upgrade fixed that, but can't replace the data I lost when 3 of them failed at the 
same time and the array got corrupted).

Having said that, it was MaxLineIII 300G drives I was looking at, so perhaps I'll wait a little 
longer and hear some more stories before I drop $$ on 15 of them.

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
