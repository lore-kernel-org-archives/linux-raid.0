From: Stephan van Hienen <raid@a2000.nu>
Subject: Re: slow raid5 performance kernel 2.6 vs 2.4
Date: Sun, 6 Mar 2005 15:23:52 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0503061523170.3998@adsl.a2000.nu>
References: <20041212211330.M51235-100000@xs3.xs4all.nl>
 <16830.28865.842641.822948@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
In-Reply-To: <16830.28865.842641.822948@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: ddx <ddx@xs4all.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Is there any news about this problem ?


On Tue, 14 Dec 2004, Neil Brown wrote:

> On Sunday December 12, ddx@xs4all.nl wrote:
>> Hi,
>>
>> system :
>>
>> P4 2.4GHz HT, 1GB DDR
>> 8*  S-ATA 250GB Hitachi on 2 Si3114 controllers
>>
>> bonnie performance with 2.4 :
>> block input 126MB/sec
>>
>> with 2.6 :
>> block input 90MB/sec
>>
>> saw another posting about slow read performance with raid5 and 2.6
>> any ideas yet how to fix this ?
>>
>
> Not yet.  I've been doing some testing which you can read about at
>    http://neilb.web.cse.unsw.edu.au/~neilb/01102979338
>
> I only get a drop from about 250 to 220 on my hardware, which still
> isn't good.
> I've got a few ideas but I'm not sure when I will have a chance to
> follow through with them.  I'm doing a bit more testing first to make
> sure I have a complete picture.
>
> NeilBrown
>
>>
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
