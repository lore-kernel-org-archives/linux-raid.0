From: Maurice Hilarius <maurice@harddata.com>
Subject: Re: Definition of hotswap, was 1x 3ware controllers vs. 2x
  3ware controllers
Date: Sun, 22 Aug 2004 11:52:32 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <6.1.2.0.2.20040822115038.084c6760@mail.harddata.com>
References: <Pine.LNX.4.44.0408010858370.7382-100000@uplift.swm.pp.se>
 <Pine.LNX.4.56.0408010804370.6442@lion.drogon.net>
 <Pine.LNX.4.58.0408021554070.7168@taurus.cesta.com>
 <1091498700.18467.286.camel@tinny.home.foo>
 <410F7D1F.90609@buttersideup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <410F7D1F.90609@buttersideup.com>
References: <Pine.LNX.4.44.0408010858370.7382-100000@uplift.swm.pp.se>
 <Pine.LNX.4.56.0408010804370.6442@lion.drogon.net>
 <Pine.LNX.4.58.0408021554070.7168@taurus.cesta.com>
 <1091498700.18467.286.camel@tinny.home.foo>
 <410F7D1F.90609@buttersideup.com>
To: Tim Small <tim@buttersideup.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

With regards to your message at 05:55 AM 8/3/04, Tim Small. Where you stated:
>Scott T. Smith wrote:
>
>>This link seems to indicate "hot swap" means telling the machine you're
>>going to remove the device, and then removing the device.  To me, that's
>>not really hot swapping; I would prefer to be able to just yank to drive
>>and let the OS figure it out itself.
>>
>>What is the common industry definition of hot swapping?
>>
>I'd say the most common definition is the ability to swap-out a failed 
>disk whilst power is connected to the system, and the OS remains up - 
>sometimes informing the controller, sometimes not..


I think one has to add to that:

"While allowing the filesystem to remain available to the OS and 
applications, and without the loss or corruption of data, preferably 
without the requirement for manual intervention by a user or administrator."



With our best regards,

Maurice W. Hilarius       Telephone: 01-780-456-9771
Hard Data Ltd.               FAX:       01-780-456-9772
11060 - 166 Avenue        mailto:maurice@harddata.com
Edmonton, AB, Canada      http://www.harddata.com/
    T5X 1Y3


