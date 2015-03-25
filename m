From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: RAID6 won't reassemble after disk controller failure
Date: Wed, 25 Mar 2015 17:09:42 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1503251707440.20507@uplift.swm.pp.se>
References: <5512D21E.1010506@sinno.net> <alpine.DEB.2.02.1503251621390.20507@uplift.swm.pp.se> <5512D3AA.5000003@sinno.net> <alpine.DEB.2.02.1503251628120.20507@uplift.swm.pp.se> <5512D79B.704@sinno.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5512D79B.704@sinno.net>
Sender: linux-raid-owner@vger.kernel.org
To: Scott Sinno <sinno@sinno.net>
Cc: linux-raid@vger.kernel.org, "Vaughan, Garrison (GSFC-606.2)[INTERNATIONAL TECHNOLOGY COALITION, INC]" <garrison.r.vaughan@nasa.gov>
List-Id: linux-raid.ids

On Wed, 25 Mar 2015, Scott Sinno wrote:

> Mikael Abrahamsson wrote:
>> Ok, next thing to recommend would be to get the latest mdadm from Niels
>> git repo and try with that one. I know some who have fixed similar
>> problems to yours by doing this.
>>
>> "git clone git://neil.brown.name/mdadm mdadm" and compile that and see
>> if --assemble --force works.
>>
>
> That constitutes a huge step forward.  Was able to assemble the array
> with all 12 drives using this binary!  Thanks so much!!!
>
> However, after stopping and re-assembling the array, using the 'stock'
> CentOS version, it yields this complaint unless '--force' is also used.
> I'm inclined to believe I should simply fail /dev/sdbt and move on, yes?

I will not make any more recommendations on how to proceed with this, it 
sounds like failing sdbt houldn't be needed and if I were you, I would 
assemble the array, keep it running until someone else who knows more can 
potentially help you with what might be wrong with your older version of 
mdadm (or the newer one might not do everything it should, or it's 
something your kernel is doing wrong).

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
