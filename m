From: =?ISO-8859-1?Q?Ralf_M=FCller?= <ralf@bj-ig.de>
Subject: Re: Very small internal bitmap after recreate
Date: Fri, 2 Nov 2007 13:46:16 +0100
Message-ID: <1DB65CCE-F7AF-42B8-B121-B98C4D430AE0@bj-ig.de>
References: <58CC73B2-35E8-412A-A7ED-8CACE786CE00@bj-ig.de> <18218.60496.499724.710572@notabene.brown> <70E97204-84DA-404E-9426-BDED1D4A1FE4@bj-ig.de> <18219.3453.415512.450789@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18219.3453.415512.450789@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Am 02.11.2007 um 12:43 schrieb Neil Brown:
>
> For now, you will have to live with a smallish bitmap, which probably
> isn't a real problem.

Ok then.

>>      Array Slot : 3 (0, 1, failed, 2, 3, 4)
>>     Array State : uuUuu 1 failed
>>
>> This time I'm getting nervous - Array State failed doesn't sound  
>> good!
>
> This is nothing to worry about - just a bad message from mdadm.
>
> The superblock has recorded that there was once a device in position 2
> which is now failed (See the list in "Array Slot").
> This summaries as "1 failed" in "Array State".
>
> But the array is definitely working OK now.

Good to know.

Thanks a lot
Ralf
