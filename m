From: Neil Brown <neilb@suse.de>
Subject: Re: 3-way mirrors
Date: Wed, 8 Sep 2010 14:16:21 +1000
Message-ID: <20100908141621.0f6221aa@notabene>
References: <20100908035852.25019.qmail@s217.sureserver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100908035852.25019.qmail@s217.sureserver.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Sallaway <michael@sallaway.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 08 Sep 2010 03:58:52 +0000
"Michael Sallaway" <michael@sallaway.com> wrote:

> >  From: Neil Brown <neilb@suse.de>
> >  Subject: Re: 3-way mirrors
> >  Sent: 07 Sep '10 22:01
> >  
> >  This is already possible via the sync_min and sync_max sysfs files.
> >  Write a number of sectors to sync_max and a lower number to sync_min.
> >  Then write 'repair' to 'sync_action'.
> >  When sync_completed reaches sync_max, the repair will pause.
> >  You can then let it continue by writing a larger number to sync_max, or tell
> >  it to finish by writing 'idle' to 'sync_action'.
> 
> Interesting... will this also work for a rebuild/recovery? If so, how do I start a rebuild from a particular location? (do I just write the sync_min sector before adding the replacement drive to the array, and it will start from there when I add it?)

Why would you want to?

sync_min is only honoured when you request a check/repair operation.  When md
determines a resync or recovery is needed, it starts the where it needs to
start from, which is normally the beginning.

You can add a new device entirely by writing to sysfs files.  In this case
you can set the 'recovery_start' for that device.  This tells md that it has
already recovered some of the array.

> 
> Are all sector counts in terms of a drive sector position, or an array sector position?

For raid10, the sector counts are array sector position.
For raid5/raid6, the sector counts are drive sector position with data_offset
subtracted (so they start from 0).

For raid1, both of the above descriptions produce the same answer, so both
are valid descriptions.

NeilBrown


> 
> Thanks,
> Michael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

