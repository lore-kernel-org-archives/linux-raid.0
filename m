From: Neil Brown <neilb@suse.de>
Subject: Re: mismatch_cnt of 128 and 1408.
Date: Tue, 25 Mar 2008 14:33:53 +1100
Message-ID: <18408.29345.627523.525932@notabene.brown>
References: <20080324083651.444cbab3@absurd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Janek Kozicki on Monday March 24
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday March 24, janek_listy@wp.pl wrote:
> 
> 5. then after reboot: /usr/share/mdadm/checkarray -a ; cat /sys/block/md?/md/mismatch_cnt
>    md0: 128
>    md1: 0
>    md2: 1408
> 
> Now I am alarmed that something might be wrong with the root
> partition. From other posts I remember that mismatch count for swap
> partitions is allowed to be nonzero.

Yes, the 'swap' is nothing to worry about.

As md does it's checks in units of around 128 sectors, the "md0: 128"
probably just means a single sector is different between the two.

I recommend

  echo repair > /sys/block/md0/md/sync_action

That will fix it.

Probably just another 'fsck -f' after that just to be on the same
side.

NeilBrown
