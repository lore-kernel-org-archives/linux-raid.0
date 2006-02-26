From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: block level vs. file level
Date: Sun, 26 Feb 2006 00:11:17 -0500
Message-ID: <44013875.8080906@tmr.com>
References: <43EF8CFB.5080403@kfa.org> <20060212213157.GX32687@strugglers.net>	 <43EFDDF7.6090405@kfa.org> <62b0912f0602200853m72af5676y4f2dcd07fe358ef8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62b0912f0602200853m72af5676y4f2dcd07fe358ef8@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: it <itech@kfa.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Molle Bestefich wrote:

>it wrote:
>  
>
>>Ouch.
>>
>>How does hardware raid deal with this? Does it?
>>    
>>
>
>Hardware RAID controllers deal with this by rounding the size of
>participant devices down to nearest GB, on the assumption that no
>drive manufacturers would have the guts to actually sell eg. a 250 GB
>drive with less than exactly 250.000.000.000 bytes of space on it.
>
>(It would be nice if the various flavors of Linux fdisk had an option
>to do this. It would be very nice if anaconda had an option to do
>this.)
>
I guess if you care you specify the size of the partition instead of 
"use it all." I use fdisk usually, cfdisk when installing, both let me 
set size, fdisk let's me set starting track and even play with the 
partition table's idea of geometry. What kind of an option did you have 
in mind?

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

