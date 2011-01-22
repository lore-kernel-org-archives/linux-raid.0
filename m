From: Spelic <spelic@shiftmail.org>
Subject: Re: Low cost PCI-E unRAID - Supermicro AOC-SASLP-MV8 Driver/LBA
 questions for HW owners/users
Date: Sun, 23 Jan 2011 00:40:53 +0100
Message-ID: <4D3B6B05.1020303@shiftmail.org>
References: <AANLkTimp7xxQTv419oL7x6L-sbrhv1ZcEqLq+CfY6gs5@mail.gmail.com>
 <4D39D8B5.1090901@hardwarefreak.com>
 <AANLkTin2UZJc8yP6DGf2fgcDemQHznch5rGozmnL+V_u@mail.gmail.com>
 <4D3B0009.6020006@hardwarefreak.com>
 <AANLkTimqNjq6H5X5dPnM8Aw5W3NWtdY7ptGqQJ3ogJmO@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <AANLkTimqNjq6H5X5dPnM8Aw5W3NWtdY7ptGqQJ3ogJmO@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/22/2011 09:36 PM, Michael Evans wrote:
>
> Also, you are half right about this being a 'dream' system.  For years
> I've been using a carefully selected 6 port motherboard, and 3 PCI-e
> 1x cards to get a total of 12 ports.

So you are trying to reach 12 ports?
C'mon don't be cheap, there are lightning-fast 16-ports HBA controllers 
from LSI, at 6.0gbit/sec, $350 or so. $25 per port is not much; it is 
much less than the cost of the disk you are attaching to it.
This frees you from the choice of the mainboard, and this is important, 
firstly because you can save $$$ in there, and secondly because if the 
mainboard fails, what are you going to do? you are going to buy another 
one with 6 ports? Difficult to find... and expensive also.
Also using 2 different controllers for your disks (part from mainboard, 
part from addon card) is a bit of pain in the *** for administration 
things, also performances would be the slowest of the two for every request.

> However I'm looking to rebuild
> that aging system and now that I have the proper funds want to do it
> with more reliable hardware.  I wanted to buy an adapter that would
> last until whatever standard comes out in another decade or so and
> handle any drives that might come on the market within that time.
>    

Right so you need 6.0gbit/sec
