From: "P. Gautschi" <linuxlist@gautschi.net>
Subject: Re: Raid5 drive fail during grow and no backup
Date: Fri, 07 Nov 2014 17:07:26 +0100
Message-ID: <545CEE3E.2060807@gautschi.net>
References: <loom.20141031T141939-473@post.gmane.org> <5455A35C.2060000@turmel.org> <loom.20141103T151703-83@post.gmane.org> <5458FC2A.1050308@turmel.org> <loom.20141105T200200-434@post.gmane.org> <loom.20141106T175806-337@post.gmane.org> <545CCAEA.6070204@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <545CCAEA.6070204@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Vince <stuff@hagenhuegel.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Interesting. I use the WD Red drives, too, and recommend them. Your drive's smartctl report is clean as far as wear & tear is concerned. That suggests a hardware problem elsewhere in your system. Bad cable, perhaps, or a failing power supply.

To me, it looks like a power problem: 50 out of 177 power cycles are power losses:

>  12 Power_Cycle_Count       -O--CK   100   100   000    -    177
> 192 Power-Off_Retract_Count -O--CK   200   200   000    -    50

I had something like this in my system due to a bad SATA power split cable.

Patrick
