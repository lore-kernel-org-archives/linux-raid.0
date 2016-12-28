From: "John Stoffel" <john@stoffel.org>
Subject: Re: SAS disk from RAID card (no RAID mode) problems
Date: Wed, 28 Dec 2016 16:28:14 -0500
Message-ID: <22628.11886.281964.981520@quad.stoffel.home>
References: <2326bdf0-2948-5cbf-3033-27ed41803e23@imagedworld.com>
        <1567104.jAPptYD2GZ@natasha>
        <ed04b869-cc0f-b099-95a8-fc1ce08a1427@imagedworld.com>
        <2822438.YHxX6ucKrv@natasha>
        <658c4d05-8105-1f02-633d-12bd8d00fb49@imagedworld.com>
        <97a5cd89-d3b7-e3e4-7b02-84e97efa7dbd@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <97a5cd89-d3b7-e3e4-7b02-84e97efa7dbd@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>
Cc: IW News <news@imagedworld.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Joe" == Joe Landman <joe.landman@gmail.com> writes:

Joe> On 12/27/2016 11:57 AM, IW News wrote:
>> On 27/12/16 17:12, Thomas Fjellstrom wrote:
>>> On Tuesday, December 27, 2016 8:53:07 AM MST IW News wrote:
>>>> On 26/12/16 22:25, Thomas Fjellstrom wrote:
>>>>> On Friday, December 23, 2016 9:01:40 AM MST IW News wrote:
>>>>> Hello,

Joe> [...]

>>>>> If thats the mvsas driver, god help you. I had nothing but 
>>>>> troubles with
>>>>> it
>>>>> for a good year or two or possibly more and it was never fixed or 
>>>>> really
>>>>> acknowledged, so I sold that card (a supermicro aoc-saslp-mv8) and 
>>>>> picked
>>>>> up a IBM m1015 (LSI 9211-8i a-like) and haven't looked back.
>>>>> 
>>>>> Basically it would reset a lot, and lock up. AND I believe it 
>>>>> caused a lot
>>>>> of silent corruption as well.
>>>> Hi,
>>>> 
>>>> So there is no support for the mvsas driver?
>>>> 
>>>> The controller is integrated in the motherboard. I could by a PCIe one
>>>> but, what's the deal them?
>>>> 
>>>> Thank you.
>>>> 
>>>> Iñigo.
>>> I don't know that there isn't support, there has been commits to that 
>>> driver
>>> pretty regularly even when i was having problems. I just found there 
>>> was no
>>> support for my particular chipset. I hope you fare better than I did. 
>>> Contact
>>> linux-scsi as was suggested, maybe they can help.
>>> 
>> I already contacted. No answer.
>> 
>> Maybe there is no mvsas developer active there now.

Joe> mvsas support under Linux is terrible.  I know you probably don't
Joe> want to hear this, but get another card.  Someone recommended an
Joe> LSI9211 card.  Past experience with those have been spotty.  They
Joe> are cheap, but I'd recommend a 9207-8i.  Costs a little more, but
Joe> generally works very well.

I bought one and it's been running rock solid in my home system for
months and months.  Got it off ebay for around $120 or so, forget the
exact price.  

Joe> Again, if you are using an mvsas based card, you should expect
Joe> problems and data corruption.  If you use the 9207, it should
Joe> work nicely.

I concur, LSI makes some solid gear.  Get the ones without the RAID
ROM too if you can, or flash it and just use it as a JBOD controller.

Mine is:

02:00.0 Serial Attached SCSI controller: LSI Logic / Symbios Logic SAS2008 PCI-Express Fusion-MPT SAS-2 [Falcon] (rev 03)
