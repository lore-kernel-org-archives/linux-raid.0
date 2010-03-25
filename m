From: Asdo <asdo@shiftmail.org>
Subject: Re: Use of WD20EARS with MDADM
Date: Thu, 25 Mar 2010 18:45:17 +0100
Message-ID: <4BABA12D.6040605@shiftmail.org>
References: <4BAB8D41.4010801@gmail.com>
 <F50E50EC-32CF-4FC4-949B-E8DA56B08D50@santools.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <F50E50EC-32CF-4FC4-949B-E8DA56B08D50@santools.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: Andrew Dunn <andrew.g.dunn@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

David Lethe wrote:
> On Mar 25, 2010, at 11:20 AM, Andrew Dunn wrote:
>   
>> Recently Dell is selling their WD20EARS (2TB) for 90$
>>
>> This being one of the best PPG (Price Per Gigabyte) snatches I have
>> seen, I was considering buying 8 of them for an mdadm array.
>>
>> Has anyone had experience with these drives?
>>
>> Note, they have 4K sectors.
>>
>> Thank you for your kind responses.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>     
>
> This is a low-cost consumer disk that is rated for a whole 2400 hours
> use in a year.  You get what you pay for. 

I think the "I" in RAID stands for inexpensive :-P
Jokes apart, don't you think frequent scrubbing (e.g. weekly for a 
raid-6 or 2/week for raid-1/10) is enough to compensate for this?
I would be way more concerned with ERC / TLER if it proves to be 
nonsettable, but I might be wrong
