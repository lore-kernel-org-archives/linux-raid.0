From: Jeremy Thompson <jeremythompson82@gmail.com>
Subject: Re: It is safe to stop Raid being reshaped
Date: Wed, 28 Dec 2011 11:06:30 -0800
Message-ID: <CAK90R-ATCf6iSgod4ktvaaiDmGaiaAPFQ+On=t0Ob4g6tUWhYA@mail.gmail.com>
References: <CAK90R-Bc8z3vOcitrqyEk0Lb7Pgr+ghwL7Zfq4HZRxJ1-jNHag@mail.gmail.com>
 <4EFB67CC.7010500@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EFB67CC.7010500@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

The RAID array consists of drives that are on cheap SATA controllers
no RAID function on them.  That is why I chose to use mdadm instead of
a true RAID card.

So the errors would happen regardless if heat was an issue?

I'll wait until the reshape is done then, shutdown the machine and
re-arrange the drives before I add another drive to the array.

Thanks.

On Wed, Dec 28, 2011 at 11:02 AM, Asdo <asdo@shiftmail.org> wrote:
> My opinion is: don't stop the array!
> Errors are not necessarily caused by heat, probably more a controller or
> firmware issue, which will present identically if you restart the reshaping
> process.
> Also, this kind of issues on my 3ware controller are harmless. You could
> better ask this to SCSI people, but there are up to 5 retries (for EACH scsi
> command) by the scsi layer after these resets happen.
> Stopping the reshape is much more risky imho.
