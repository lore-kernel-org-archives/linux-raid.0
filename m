From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Kernel 2.6.23.9 / P35 Chipset + WD 750GB Drives (reset port)
Date: Sat, 1 Dec 2007 07:23:41 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0712010722590.28887@p34.internal.lan>
References: <Pine.LNX.4.64.0712010619150.25643@p34.internal.lan>
 <Pine.LNX.4.64.0712011310410.30316@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754315AbXLAMX6@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0712011310410.30316@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, apiszcz@solarrain.com
List-Id: linux-raid.ids



On Sat, 1 Dec 2007, Jan Engelhardt wrote:

>
> On Dec 1 2007 06:26, Justin Piszcz wrote:
>> I ran the following:
>>
>> dd if=/dev/zero of=/dev/sdc
>> dd if=/dev/zero of=/dev/sdd
>> dd if=/dev/zero of=/dev/sde
>>
>> (as it is always a very good idea to do this with any new disk)
>
> Why would you care about what's on the disk? fdisk, mkfs and
> the day-to-day operation will overwrite it _anyway_.
>
> (If you think the disk is not empty, you should look at it
> and copy off all usable warez beforehand :-)
>

The purpose is with any new disk its good to write to all the blocks and 
let the drive to all of the re-mapping before you put 'real' data on it. 
Let it crap out or fail before I put my data on it.

Justin.
