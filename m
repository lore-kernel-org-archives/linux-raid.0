From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Linux: Why software RAID?
Date: Mon, 04 Sep 2006 13:31:27 -0400
Message-ID: <44FC62EF.7040100@tmr.com>
References: <20060824090741.J30362@mail.kroptech.com>	 <1156425650.3007.140.camel@localhost.localdomain>	 <44EDB843.2020608@perkel.com> <1156432892.3007.155.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1156432892.3007.155.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Marc Perkel <marc@perkel.com>, Adam Kropelin <akropel1@rochester.rr.com>, Jeff Garzik <jeff@garzik.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Alan Cox wrote:

>Ar Iau, 2006-08-24 am 07:31 -0700, ysgrifennodd Marc Perkel:
>  
>
>>So - the bottom line answer to my question is that unless you are
>>running raid 5 and you have a high powered raid card with cache and
>>battery backup that there is no significant speed increase to use
>>hardware raid. For raid 0 there is no advantage.
>>
>>    
>>
>If your raid is entirely on PCI plug in cards and you are doing RAID1
>there is a speed up using hardware assisted raid because of the PCI bus
>contention.
>

I would expect to see this with RAID5 as well, for the same reason...

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

