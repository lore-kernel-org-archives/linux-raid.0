From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] (2nd try) force parallel resync
Date: Fri, 7 Dec 2007 13:10:37 +1100
Message-ID: <18264.43933.856112.52203@notabene.brown>
References: <200712062006.15406.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bernd Schubert on Thursday December 6
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bs@q-leap.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday December 6, bs@q-leap.de wrote:
> Hello,
> 
> here is the second version of the patch. With this version also on  
> setting /sys/block/*/md/sync_force_parallel the sync_thread is woken up. 
> Though, I still don't understand why md_wakeup_thread() is not working.

Could give a little more detail on why you want this?  When do you
want multiple arrays on the same device to sync at the same time?
What exactly is the hardware like?

md threads generally run for a little while to perform some task, then
stop and wait to be needed again.  md_wakeup_thread says "you are
needed again".

The resync/recovery thread is a bit different.  It just run md_do_sync
once.  md_wakeup_thread is not really meaningful in that context.

What you want is:
		wake_up(&resync_wait);

that will get any thread that is waiting for some other array to
resync to wake up and see if something needs to be done.

NeilBrown
