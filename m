From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: extremely tiny race window in raid1
Date: Wed, 12 Jan 2005 11:26:35 +1100
Message-ID: <16868.28347.248250.674152@cse.unsw.edu.au>
References: <mcndb2-6m8.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Peter T. Breuer on Tuesday January 11
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday January 11, ptb@lab.it.uc3m.es wrote:
>  From raid1.c in 2.6.8.1:
> 
>          * inc refcount on their rdev.  Record them by setting
>          * bios[x] to bio
>          */
> -       disks = conf->raid_disks;
>         spin_lock_irq(&conf->device_lock);
> +       disks = conf->raid_disks;
>         for (i = 0;  i < disks; i++) {
>                 if (conf->mirrors[i].rdev &&
>                     !conf->mirrors[i].rdev->faulty) {
> 
> (there are plenty of other places where small things like that happen,
> and normally I say "shucks, he'll spot it and correct it, and it's no
> biggie anyway", but my conscience is getting at me to report at least
> some of them).

Patches are always welcome (preferably against the most recent kernel,
and with headers that make it easy to apply) -- I'm sure I miss plenty
of stuff.

This one, however, is not needed.  raid_disks simply cannot change at
this point.
It is only changed by raid1_reshape, and that raises a barrier to
new requests and then waits for all current requests to complete
before changing raid_disks.

NeilBrown
