From: "=?iso-8859-1?Q?Michael=20Sallaway?=" <michael@sallaway.com>
Subject: =?iso-8859-1?B?UmU6IDMtd2F5IG1pcnJvcnM=?=
Date: Wed, 08 Sep 2010 03:58:52 +0000
Message-ID: <20100908035852.25019.qmail@s217.sureserver.com>
Reply-To: "=?iso-8859-1?Q?Michael=20Sallaway?=" <michael@sallaway.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>  From: Neil Brown <neilb@suse.de>
>  Subject: Re: 3-way mirrors
>  Sent: 07 Sep '10 22:01
>  
>  This is already possible via the sync_min and sync_max sysfs files.
>  Write a number of sectors to sync_max and a lower number to sync_min.
>  Then write 'repair' to 'sync_action'.
>  When sync_completed reaches sync_max, the repair will pause.
>  You can then let it continue by writing a larger number to sync_max, or tell
>  it to finish by writing 'idle' to 'sync_action'.

Interesting... will this also work for a rebuild/recovery? If so, how do I start a rebuild from a particular location? (do I just write the sync_min sector before adding the replacement drive to the array, and it will start from there when I add it?)

Are all sector counts in terms of a drive sector position, or an array sector position?

Thanks,
Michael
