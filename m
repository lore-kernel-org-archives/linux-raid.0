From: Tim Small <tim@buttersideup.com>
Subject: Re: Definition of hotswap, was 1x 3ware controllers vs. 2x 3ware
 controllers
Date: Tue, 03 Aug 2004 12:55:11 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <410F7D1F.90609@buttersideup.com>
References: <Pine.LNX.4.44.0408010858370.7382-100000@uplift.swm.pp.se>	 <Pine.LNX.4.56.0408010804370.6442@lion.drogon.net>	 <Pine.LNX.4.58.0408021554070.7168@taurus.cesta.com> <1091498700.18467.286.camel@tinny.home.foo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1091498700.18467.286.camel@tinny.home.foo>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Scott T. Smith wrote:

>This link seems to indicate "hot swap" means telling the machine you're
>going to remove the device, and then removing the device.  To me, that's
>not really hot swapping; I would prefer to be able to just yank to drive
>and let the OS figure it out itself.
>
>What is the common industry definition of hot swapping?
>  
>
I'd say the most common definition is the ability to swap-out a failed 
disk whilst power is connected to the system, and the OS remains up - 
sometimes informing the controller, sometimes not..

