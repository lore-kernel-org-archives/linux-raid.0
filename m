From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: sw raid0 read bottleneck
Date: Tue, 13 Mar 2007 14:42:01 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0703131441590.29504@p34.internal.lan>
References: <Pine.LNX.4.64.0703131713280.18749@localhost.localdomain>
 <Pine.LNX.4.64.0703131248260.29504@p34.internal.lan>
 <Pine.LNX.4.64.0703131815050.18749@localhost.localdomain>
 <Pine.LNX.4.64.0703131914360.18749@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0703131914360.18749@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Tomka Gergely <gergely@tomka.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Nice.

On Tue, 13 Mar 2007, Tomka Gergely wrote:

> On Tue, 13 Mar 2007, Tomka Gergely wrote:
>
>> On Tue, 13 Mar 2007, Justin Piszcz wrote:
>>
>>> Have you tried increasing your readahead values for the md device?
>>
>> Yes. No real change. According to my humble mental image, readahead not a
>> too useful thing, when we read 1-4 thread with sdd. The io subsystem
>> already reading with the possible maximum speed, so don't have time to
>> read ahead. Correct me, if i wrong.
>
> I was wrong, readahead can speed things up, to 450 MBps.
>
> -- 
> Tomka Gergely, gergely@tomka.hu
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
