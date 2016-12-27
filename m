From: IW News <news@imagedworld.com>
Subject: Re: SAS disk from RAID card (no RAID mode) problems
Date: Tue, 27 Dec 2016 17:57:28 +0100
Message-ID: <658c4d05-8105-1f02-633d-12bd8d00fb49@imagedworld.com>
References: <2326bdf0-2948-5cbf-3033-27ed41803e23@imagedworld.com>
 <1567104.jAPptYD2GZ@natasha>
 <ed04b869-cc0f-b099-95a8-fc1ce08a1427@imagedworld.com>
 <2822438.YHxX6ucKrv@natasha>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2822438.YHxX6ucKrv@natasha>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 27/12/16 17:12, Thomas Fjellstrom wrote:
> On Tuesday, December 27, 2016 8:53:07 AM MST IW News wrote:
>> On 26/12/16 22:25, Thomas Fjellstrom wrote:
>>> On Friday, December 23, 2016 9:01:40 AM MST IW News wrote:
>>>> Hello,
>>>>
>>>> First message here.
>>>>
>>>> After looking for a solution without any luck I have found this list. I
>>>> hope someone can help me with this.
>>>>
>>>> I have an ASUS P6T Deluxe with a MARVELL 88SE63xx SAS RAID controller.
>>>> There are to identical 400GB SAS SSD drives attached to it. One of them
>>>> has a Windows 10 installation, the other one Linux.
>>>> Grub is installed on the second disk.
>>>>
>>>> Windows works as expected, but I have problems with the Linux
>>>> installation: the desktop environment freezes for some second once in a
>>>> while. This occurs with Mint Cinnamon, OpenSuSe KDE, Ubuntu and Manjaro
>>>> KDE. All of them are current installations. I'm now working in up to
>>>> date Manjaro KDE (kernel 4.9.0).
>>>> When the temporary freezes occur the mouse pointer moves, some windows
>>>> are updated correctly, other do not and DE stops working.
>>>> When this happens always I have a system log like this:
>>> If thats the mvsas driver, god help you. I had nothing but troubles with
>>> it
>>> for a good year or two or possibly more and it was never fixed or really
>>> acknowledged, so I sold that card (a supermicro aoc-saslp-mv8) and picked
>>> up a IBM m1015 (LSI 9211-8i a-like) and haven't looked back.
>>>
>>> Basically it would reset a lot, and lock up. AND I believe it caused a lot
>>> of silent corruption as well.
>> Hi,
>>
>> So there is no support for the mvsas driver?
>>
>> The controller is integrated in the motherboard. I could by a PCIe one
>> but, what's the deal them?
>>
>> Thank you.
>>
>> Iñigo.
> I don't know that there isn't support, there has been commits to that driver
> pretty regularly even when i was having problems. I just found there was no
> support for my particular chipset. I hope you fare better than I did. Contact
> linux-scsi as was suggested, maybe they can help.
>
I already contacted. No answer.

Maybe there is no mvsas developer active there now.

