From: Gerd Knops <gerti@bitart.com>
Subject: Re: md confused by changing device names?
Date: Thu, 7 Oct 2004 19:11:09 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <8E9589E5-18BE-11D9-B27F-00039363AEBE@bitart.com>
References: <16ADEDFA-1898-11D9-B27F-00039363AEBE@bitart.com> <16741.51528.247736.520728@cse.unsw.edu.au> <8A1A64EE-18B4-11D9-B27F-00039363AEBE@bitart.com> <16741.53294.795263.136032@cse.unsw.edu.au>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16741.53294.795263.136032@cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Oct 7, 2004, at 6:24 PM, Neil Brown wrote:

> On Thursday October 7, gerti@bitart.com wrote:
>>>> Now when md starts it accepts sda1, kicks off sdb1 as outdated, and
>>>> never seems to even look at sdc1. Hence it will not start the array.
>>>
>>> Let me guess:  You are using "raidstart" to start the array.
>>> Don't.  It doesn't work.
>>> Use "mdadm".  It does.
>>>
>> Actually in the first round of tests I used mdadm, and in the same
>> situation it just segfaults.
>>
>
> Well, that is something I can help with.
> Can you try again and get an 'strace' showing where the segfault is,
> or a gdb stacktrace from the core file??
>
I tested some more, I must have made a mistake earlier (maybe mixed 
some raidtools command in). mdadm indeed masters that scenario fine. 
Apologies to Neil!

Gerd

> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" 
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

