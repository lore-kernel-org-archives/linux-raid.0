From: Stephan van Hienen <raid@a2000.nu>
Subject: Re: [PATCH md ] Better handling of readerrors with raid5.
Date: Thu, 22 Dec 2005 23:23:13 +0100 (CET)
Message-ID: <Pine.LNX.4.63.0512222316240.19051@adsl.a2000.nu>
References: <20050916125754.11044.patches@notabene> <1050916030157.11071@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1050916030157.11071@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 16 Sep 2005, NeilBrown wrote:

> TESTERS WANTED!!  SEE BELOW...
>
> This patch changes the behaviour of raid5 when it gets a read error.
> Instead of just failing the device, it tried to find out what should
> have been there, and writes it over the bad block.  For some
> media-errors, this has a reasonable chance of fixing the error.
> If the write succeeds, and a subsequent read succeeds as well, raid5
> decided the address is OK and conitnues.

Neil,

what is the current status of this patch ?
yesterday one of my disks decided to fail during the night (3ware ide 
timeout)
during the rebuild one of my disks decided it had a read error so the raid 
was 'down'

i recovered my raid by using dd_rescue the last failed disk to a spare 
disk (with 4 read errors)
(and doing a mdadm -A -force)

(so I should have a corrupted file somewhere?)

looks like this patch would help in situations like this
