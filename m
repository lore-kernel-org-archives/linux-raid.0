From: Mark Lord <lkml@rtr.ca>
Subject: Re: Linux: Why software RAID?
Date: Thu, 24 Aug 2006 10:55:57 -0400
Message-ID: <44EDBDFD.6030908@rtr.ca>
References: <20060824090741.J30362@mail.kroptech.com> <1156425650.3007.140.camel@localhost.localdomain> <20060824093616.K30362@mail.kroptech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060824093616.K30362@mail.kroptech.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kropelin <akropel1@rochester.rr.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, marc@perkel.com
List-Id: linux-raid.ids

Adam Kropelin wrote:
> On Thu, Aug 24, 2006 at 02:20:50PM +0100, Alan Cox wrote:
>> Generally speaking the channels on onboard ATA are independant with any
>> vaguely modern card. 
> 
> Ahh, I did not know that. Does this apply to master/slave connections on
> the same PATA cable as well?

No, it doesn't.  Except for cards which use special cables,
such as the Pacific Digital ADMA cards (which can even run both
master and slave simultaneously on a cable, though not with
the current Linux drivers).

Cheers
