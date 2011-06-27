From: David Brown <david@westcontrol.com>
Subject: Re: clarifying what can be done during resync
Date: Mon, 27 Jun 2011 14:55:42 +0200
Message-ID: <iu9unn$jib$1@dough.gmane.org>
References: <C70A636B101FD44999B82525C3E92AFAD374BD@otis.burlington.evertz.tv> <20110627154729.521e875a@notabene.brown> <C70A636B101FD44999B82525C3E92AFAD376C7@otis.burlington.evertz.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C70A636B101FD44999B82525C3E92AFAD376C7@otis.burlington.evertz.tv>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


The whole point of raid is to minimize downtime - that means that if a 
disk fails, you can remove it, replace it, and resync while everything 
is running (albeit a bit slower).



On 27/06/2011 14:35, Sandra Escandor wrote:
> Thanks for clarifying, Neil. I actually came across this on someone's
> blog explaining how they got RAID10 (with imsm metadata) up and running,
> and he mentions that he made sure to wait until resync was done before
> mounting. I did the same thing, thinking that maybe I might break
> something if I didn't.
>
> Sandra
>
> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Monday, June 27, 2011 1:47 AM
> To: Sandra Escandor
> Cc: linux-raid@vger.kernel.org
> Subject: Re: clarifying what can be done during resync
>
> On Thu, 23 Jun 2011 15:38:06 -0400 "Sandra Escandor"
> <sescandor@evertz.com>
> wrote:
>
>> Hello,
>>
>> Just wanted to make sure if this was a myth or not: Is it true that
> when
>> an array is in resync status, then mounting it is not at all possible?
>>
>
> Pure myth.  Where did you hear it?
>
> Best approach is to try .. if it is not at all possible, then it won't
> work.
> But in fact it does :-)
>
> NeilBrown
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


