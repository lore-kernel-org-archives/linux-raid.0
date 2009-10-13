From: Asdo <asdo@shiftmail.org>
Subject: Re: xfs > md 50% write performance drop on .30+ kernel?
Date: Tue, 13 Oct 2009 16:30:18 +0200
Message-ID: <4AD48EFA.50303@shiftmail.org>
References: <66781b10910120958k4afb637ejba79e4c23900c4da@mail.gmail.com>
 <20091013013352.GA24869@infradead.org>
 <66781b10910130406s4119985fg5db7679a2e9fd4f2@mail.gmail.com>
 <70ed7c3e0910130409r1e1350b6yabfdc3d4f5c51edf@mail.gmail.com>
 <66781b10910130412x309d9de2l574ba12a9ed4100a@mail.gmail.com>
 <70ed7c3e0910130415k4da86d18kd92dce5217b8600d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <70ed7c3e0910130415k4da86d18kd92dce5217b8600d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mark delfman <markdelfman@googlemail.com>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


> On Tue, Oct 13, 2009 at 2:12 PM, mark delfman
> <markdelfman@googlemail.com> wrote:
>   
>> We upgrading mainly because of support for the emerging LSI SAS2 cards
>> (which we are beta testing now)
>>     

What is this LSI SAS2 card you have with 10+ ports? The only 10+ ports 
LSI card I see is the 84016E and it is a SAS1.

You say the driver for such card is included in the vanilla kernel at 
2.6.30? That would be very nice... I grepped the 2.6.31 kernel source 
for LSI cards but I can't find device strings such as 84016E ...

Thank you
