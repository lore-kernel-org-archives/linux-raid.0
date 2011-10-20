From: Yathindra <ydev@cs.utah.edu>
Subject: Re: mdadm help
Date: Wed, 19 Oct 2011 21:12:03 -0600
Message-ID: <4E9F9183.1040809@cs.utah.edu>
References: <4E9F8C37.1060706@cs.utah.edu> <20111020140315.716d9c2e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111020140315.716d9c2e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks Neil.

On 10/19/2011 9:03 PM, NeilBrown wrote:
> On Wed, 19 Oct 2011 20:49:27 -0600 Yathindra<ydev@cs.utah.edu>  wrote:
>
>> Hi,
>>
>> I'm trying to use the faulty personality of mdadm tool to inject various
>> disk failure patterns
>> such as medium errors, unresponsive disk etc.
>>
>> I'm wondering if there is an option to delay commands to get an
>> unresponsive behavior.
> No, there is no way to get a delay.  You either get a success or a failure.
>
>> Also, does rt (readtransient) and wt (writetransient) fault options act
>> as medium errors.
> They simple report an error.  The linux block layer doesn't distinguish
> reliably amongst different types or errors (or it didn't last time I checked).
>
> NeilBrown
>
>
>> Thanks,
>> Yathi
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

