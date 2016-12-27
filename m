From: Joe Landman <joe.landman@gmail.com>
Subject: Re: SAS disk from RAID card (no RAID mode) problems
Date: Tue, 27 Dec 2016 12:09:52 -0500
Message-ID: <97a5cd89-d3b7-e3e4-7b02-84e97efa7dbd@gmail.com>
References: <2326bdf0-2948-5cbf-3033-27ed41803e23@imagedworld.com>
 <1567104.jAPptYD2GZ@natasha>
 <ed04b869-cc0f-b099-95a8-fc1ce08a1427@imagedworld.com>
 <2822438.YHxX6ucKrv@natasha>
 <658c4d05-8105-1f02-633d-12bd8d00fb49@imagedworld.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <658c4d05-8105-1f02-633d-12bd8d00fb49@imagedworld.com>
Sender: linux-raid-owner@vger.kernel.org
To: IW News <news@imagedworld.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 12/27/2016 11:57 AM, IW News wrote:
> On 27/12/16 17:12, Thomas Fjellstrom wrote:
>> On Tuesday, December 27, 2016 8:53:07 AM MST IW News wrote:
>>> On 26/12/16 22:25, Thomas Fjellstrom wrote:
>>>> On Friday, December 23, 2016 9:01:40 AM MST IW News wrote:
>>>>> Hello,

[...]

>>>>> If thats the mvsas driver, god help you. I had nothing but 
>>>>> troubles with
>>>> it
>>>> for a good year or two or possibly more and it was never fixed or 
>>>> really
>>>> acknowledged, so I sold that card (a supermicro aoc-saslp-mv8) and 
>>>> picked
>>>> up a IBM m1015 (LSI 9211-8i a-like) and haven't looked back.
>>>>
>>>> Basically it would reset a lot, and lock up. AND I believe it 
>>>> caused a lot
>>>> of silent corruption as well.
>>> Hi,
>>>
>>> So there is no support for the mvsas driver?
>>>
>>> The controller is integrated in the motherboard. I could by a PCIe one
>>> but, what's the deal them?
>>>
>>> Thank you.
>>>
>>> Iñigo.
>> I don't know that there isn't support, there has been commits to that 
>> driver
>> pretty regularly even when i was having problems. I just found there 
>> was no
>> support for my particular chipset. I hope you fare better than I did. 
>> Contact
>> linux-scsi as was suggested, maybe they can help.
>>
> I already contacted. No answer.
>
> Maybe there is no mvsas developer active there now.

mvsas support under Linux is terrible.   I know you probably don't want 
to hear this, but get another card.   Someone recommended an LSI9211 
card.  Past experience with those have been spotty.  They are cheap, but 
I'd recommend a 9207-8i.  Costs a little more, but generally works very 
well.

Again, if you are using an mvsas based card, you should expect problems 
and data corruption.  If you use the 9207, it should work nicely.

The windows world has all sorts of workarounds for wonky cards/chipsets 
in their drivers.  Generally, if the driver is not actively supported in 
linux and up to date, you are likely going to have problems.  If others 
are reporting problems (google "mvsas problems in linux" if you want to 
see how long people have been having problems with the cards), stay far 
away from it.

-- 
Joe Landman
e: joe.landman@gmail.com
t: @hpcjoe
c: +1 734 612 4615
w: https://scalability.org

