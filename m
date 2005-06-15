From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: sata_nv and RAID1
Date: Tue, 14 Jun 2005 20:12:06 -0400
Message-ID: <42AF7256.1040900@pobox.com>
References: <200506111613.42962.dvadell@lantech.com.ar>	 <20050611192606.GA4055@pentafluge.infradead.org>	 <42AB49BC.50104@tls.msk.ru> <42AD2B85.30303@pobox.com>	 <42AD74BD.8050704@tls.msk.ru>	 <62b0912f05061414116f7afedc@mail.gmail.com>	 <42AF4E17.2040900@tls.msk.ru>	 <62b0912f0506141526358647d0@mail.gmail.com> <42AF631C.1050806@tmr.com> <62b0912f050614161875a4913c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62b0912f050614161875a4913c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: Bill Davidsen <davidsen@tmr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Molle Bestefich wrote:
> Bill Davidsen wrote:
> 
>>Molle Bestefich wrote:
>>
>>>So you don't care that your Linux system will deadlock if a PATA disk
>>>is removed, for instance?  Just an example, one that I've seen happen
>>>a couple of times.  Never seen it with Windows, it just tells you that
>>>the disk is gone.
>>
>>Actually I suspect most Linux users are smart enough not to pull a PATA
>>drive out while in use, and it works just fine if you offline the drive
>>before removal.
> 
> 
> That's not a good argument, other things can happen to throw a disk offline.
> Flaky IDE or power cables and disk failure come to mind.

Linux handles these just fine.

	Jeff



