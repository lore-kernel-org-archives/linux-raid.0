From: Steve Cousins <steve.cousins@maine.edu>
Subject: Re: MD write performance issue - found Catalyst patches
Date: Wed, 04 Nov 2009 14:05:45 -0500
Message-ID: <4AF1D089.5080901@maine.edu>
References: <66781b10910180300j2006a4b7q21444bb27dd9434e@mail.gmail.com>	 <19177.14609.138378.581065@notabene.brown>	 <4AE94D95.4060303@shiftmail.org>	 <66781b10910310351x7bb721c4mfba765fe9789cd7b@mail.gmail.com>	 <19183.47226.529417.743975@notabene.brown>	 <66781b10911030411y5bb32610lec72966f7cc09df@mail.gmail.com> <66781b10911040915t11a7f0c2td6a9ed5672935efb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <66781b10911040915t11a7f0c2td6a9ed5672935efb@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mark delfman <markdelfman@googlemail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

mark delfman wrote:
> Some FS comparisons attached in pdf
>
> not sure what to make of them as yet, but worth posting
>   

I'm not sure either. Two things jump out.
 
    1. Why is raw RAID0 read performance slower than write performance
    2. Why is read performance with some file systems at or above raw 
read performance?

For number one, does this indicate that write caching is actually On on 
the drives?

Are all tests truly apples-apples comparisons or were there other 
factors in there that aren't listed in the charts?

I guess these issues might not have a lot to do with your main question 
but you might want to double-check the tests and numbers.

Steve
