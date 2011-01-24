From: "Sven Eschenberg" <sven@whgl.uni-frankfurt.de>
Subject: Re: Low cost PCI-E unRAID - Supermicro AOC-SASLP-MV8 Driver/LBA
     questions for HW owners/users
Date: Mon, 24 Jan 2011 12:45:07 +0100 (CET)
Message-ID: <4e5d3b19722645eed2d3de31c5c71dc0.squirrel@ssl.verfeiert.org>
References: <AANLkTimp7xxQTv419oL7x6L-sbrhv1ZcEqLq+CfY6gs5@mail.gmail.com>
    <4D39D8B5.1090901@hardwarefreak.com>
    <AANLkTin2UZJc8yP6DGf2fgcDemQHznch5rGozmnL+V_u@mail.gmail.com>
    <4D3B0009.6020006@hardwarefreak.com>
    <AANLkTimqNjq6H5X5dPnM8Aw5W3NWtdY7ptGqQJ3ogJmO@mail.gmail.com>
    <4D3B6B05.1020303@shiftmail.org> <4D3B9617.9010800@tomt.net>
    <4D3BA7E3.1070400@shiftmail.org>
Reply-To: sven@whgl.uni-frankfurt.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D3BA7E3.1070400@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Would you mind explaining what you mean by mapping and why this should be
an issue? Or are you suggesting, when talking about drive letter, to still
use sdN names when handling drives? Because that seems to be somewhat from
the dark ages...


On Sun, January 23, 2011 05:00, Spelic wrote:
> On 01/23/2011 03:44 AM, Andre Tomt wrote:
>>
>> Since we're talking about "non hardware raid" usage, I don't really
>> understand how it would be harder to manage mixed controllers? Care to
>> explain?
>
> Well, yeah, probably I have exxagerated. If you need to replace a drive
> you have to associate the drive letter to the hardware slot, and if you
> have two controllers you have to remember two mappings. Also you have to
> know the idiosincracies of 2 controllers, like, do they support hot swap
> or they freeze? Do the support smartmontools well or not, are both
> capable of withstanding high IOPS situation or one drops out and
> degrades the array... but probably the OP can accept these drawbacks.
>


