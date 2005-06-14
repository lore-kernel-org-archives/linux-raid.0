From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: sata_nv and RAID1
Date: Wed, 15 Jun 2005 02:17:57 +0400
Message-ID: <42AF5795.2060006@tls.msk.ru>
References: <200506111613.42962.dvadell@lantech.com.ar>	 <20050611192606.GA4055@pentafluge.infradead.org>	 <42AB49BC.50104@tls.msk.ru> <42AD2B85.30303@pobox.com>	 <42AD74BD.8050704@tls.msk.ru> <62b0912f05061414116f7afedc@mail.gmail.com> <42AF4E17.2040900@tls.msk.ru> <42AF55D3.1090704@lantech.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42AF55D3.1090704@lantech.com.ar>
Sender: linux-raid-owner@vger.kernel.org
To: "Diego M. Vadell" <dvadell@lantech.com.ar>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Diego M. Vadell wrote:
> Michael Tokarev wrote:
> 
>>
>> I for one don't care (for now) about SATA and hot[un]plug for
>> harddrives.  
> 
> Hi Michael,
>   Why don't you care? Is it so unlikely to get a hard disk as broken as 
> if it looked the same as if it were unplugged? I mean, am I worrying too 
> much.

Heh.  Just Because (tm?) I don't have any SATA drives (for now).
And it's unlikely for me to see them in the near future, for
various resasons, one of them is because I tend to use SCSI
if at all possible...  ;)

SATA *still* is quite new, and there isn't much *good* SATA
hardware out there (think NCQ for example, which just does
not exists on alot of controllers and harddrives; and 5-years
old average SCSI disk performs alot better on random I/O
compared to modern *good* EIDE (no SATA here, remember?)
disk, even when the latter is much faster on linear I/O,
with larger cache etc...).  All that "PATA to SATA converters"
still built into some drives which are really PATA internally
but made to work on SATA bus with a converter..  and other
scary things... ;)

/mjt
