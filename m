From: Asdo <asdo@shiftmail.org>
Subject: Re: It is safe to stop Raid being reshaped
Date: Thu, 29 Dec 2011 03:02:47 +0100
Message-ID: <4EFBCA47.9010401@shiftmail.org>
References: <CAK90R-Bc8z3vOcitrqyEk0Lb7Pgr+ghwL7Zfq4HZRxJ1-jNHag@mail.gmail.com>
 <4EFB67CC.7010500@shiftmail.org>
 <CAK90R-ATCf6iSgod4ktvaaiDmGaiaAPFQ+On=t0Ob4g6tUWhYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <CAK90R-ATCf6iSgod4ktvaaiDmGaiaAPFQ+On=t0Ob4g6tUWhYA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeremy Thompson <jeremythompson82@gmail.com>
Cc: Asdo <asdo@shiftmail.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/28/11 20:06, Jeremy Thompson wrote:
> The RAID array consists of drives that are on cheap SATA controllers
> no RAID function on them.  That is why I chose to use mdadm instead of
> a true RAID card.

Me too, I meant 3ware used as classic sata controller

> So the errors would happen regardless if heat was an issue?

I think that with temperature you would get a different error: disk 
going completely offline due to thermal shutdown.
Anyway Gordon showed you how to check for temperatures; try that.
Another way is via "smartctl -a /dev/sdX"

SCSI errors are usually due to cabling, not perfect firmware, not 
perfect controller, not perfect controller drivers.
If you show us the exact error we can be a bit more precise.
Note: 5 retries (for each scsi command) by the SCSI layer also applies 
to SATA disks, which is your case

> I'll wait until the reshape is done then, shutdown the machine and
> re-arrange the drives before I add another drive to the array.

Yes this would be my suggestion, but I don't know everything.

Have a look at the temperatures though, and compare to max temp by your 
HDD specs. I suggest you don't stop the array if they are lower.
