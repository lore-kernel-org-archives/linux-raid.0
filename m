From: Jan Ceuleers <jan.ceuleers@computer.org>
Subject: Re: How can I tell what drive is sdb?
Date: Wed, 27 Jan 2010 15:18:19 +0100
Message-ID: <4B604B2B.7070602@computer.org>
References: <1264601024.29409.19.camel@thor> <bdd6985b1001270609m477799dpdcd625180efaed02@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bdd6985b1001270609m477799dpdcd625180efaed02@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Matt Garman wrote:
>> Is there a way to identify what drive is what?
> 
> Sometimes you can infer from dmesg.  E.g., type "dmesg | less" then
> scroll until you see where sdb is initialized; it might show the model
> and serial number of the drive.
> 
> Another approach is to use smartctl, i.e.: "sudo smartctl -a
> /dev/sdb".  This will definitely show you the model and serial number.
>  You can also use hdparm for the same effect: "sudo hdparm -I
> /dev/sdb".
> 
> I'm sure there's more ways, but those are the first that come to mind.

I'm guessing that the OP is looking for ways to identify disks without disassembling them all.

In the networking world, you can ask the system to tell you which network interface is which, by blinking the network LEDs (using ethtool -p). Is there something similar for disks?
