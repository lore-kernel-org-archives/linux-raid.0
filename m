From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Was: [RFC PATCH 2.6.23.1] md: add dm-raid1 read balancing
Date: Thu, 08 Nov 2007 12:24:34 -0500
Message-ID: <47334652.6040109@tmr.com>
References: <1194084522.1353.10.camel@localhost>	<87fxziju0z.fsf@informatik.uni-tuebingen.de>	<1194520008.17369.19.camel@localhost>	<87prykaeh6.fsf@informatik.uni-tuebingen.de> <20071108120625.7e0572b1@bree.surriel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071108120625.7e0572b1@bree.surriel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Rik van Riel <riel@redhat.com>
Cc: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>, konstantin.sharlaimov@gmail.com, linux-raid <linux-raid@vger.kernel.org>, "; Ingo Molnar" <mingo@redhat.com>, "; Neil Brown" <neilb@suse.de>
List-Id: linux-raid.ids

Rik van Riel wrote:
> On Thu, 08 Nov 2007 17:28:37 +0100
> Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de> wrote:
>
>   
>> Maybe you need more parameter:
>>     
>
> Generally a bad idea, unless you can come up with sane defaults (which
> do not need tuning 99% of the time) or you can derive these parameters
> automatically from the RAID configuration (unlikely with RAID 1?).
>
> Before turning Konstantin's nice and simple code into something complex,
> it would be good to see benchmark results show that the complexity is
> actually needed.
>
>   
I was about to post a question about the benefit of all this logic, I'll 
trim before posting...

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

