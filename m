From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: make filesystem failed while the capacity of raid5 is big than
 16TB
Date: Thu, 13 Sep 2012 17:47:41 -0500
Message-ID: <5052628D.6090600@hardwarefreak.com>
References: <505033fe.8aec440a.5d52.ffffe37b@mx.google.com> <50504094.2040302@hesbynett.no> <CACY-59cLmV2SRY+FrvhHxseDD1+r-B-3bOKPGzJdGttW+9U2mw@mail.gmail.com> <505059DD.8000108@hesbynett.no> <CACY-59dAbS=8ncRAeZrAYBAvo7G6FEyoGREHtC-ze4cwhiF9GQ@mail.gmail.com> <5051DEC3.9050703@hardwarefreak.com> <5051E515.4030106@hesbynett.no>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5051E515.4030106@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: GuoZhong Han <hanguozhong@meganovo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9/13/2012 8:52 AM, David Brown wrote:
> On 13/09/2012 15:25, Stan Hoeppner wrote:

>> If I were doing such a product, I'd immediately toss out the 36 core
>> logic platform and switch to a low power single/dual core x86 chip.
> 
> I'd go for at least two, but probably four cores - the difference in
> price is going to be irrelevant compared to the rest of the hardware.
> But I agree that large numbers of cores are probably wasted.

Price is only one concern of many.  With an embedded storage appliance
TDP and low power draw are as important as price.  For instance, a 64bit
dual core, 4 thread 1.86GHz Intel Atom N2800 has a TDP of 6.5 watts.
Each core is easily capable of handling IO and parity for 8 rust drives
making it an excellent fit for this storage appliance.  There are dual
core MIPS64 chips that are suitable as well.

-- 
Stan


