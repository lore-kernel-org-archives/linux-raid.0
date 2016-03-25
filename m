From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [BUG] NULL pointer in raid1_make_request passed to bio_trim when
 adding md as bcache caching dev
Date: Fri, 25 Mar 2016 21:32:20 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1603252117250.13440@mail.ewheeler.net>
References: <56F4058B.1030309@roesner-online.de> <alpine.LRH.2.11.1603250126110.13440@mail.ewheeler.net> <alpine.LRH.2.11.1603250416030.13440@mail.ewheeler.net> <56F54712.6090202@roesner-online.de> <alpine.LRH.2.11.1603251954220.13440@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.11.1603251954220.13440@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
To: Sebastian Roesner <sroesner-kernelorg@roesner-online.de>
Cc: linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, mlin@kernel.org, miuvlad@gmail.com, ming.lei@canonical.com, rjones@redhat.com, kent.overstreet@gmail.com
List-Id: linux-raid.ids

On Fri, 25 Mar 2016, Eric Wheeler wrote:
> On Fri, 25 Mar 2016, Sebastian Roesner wrote:
> 
> > Hi Eric,
> > 
> > Am 25.03.2016 um 05:18 schrieb Eric Wheeler:
> > > Please send this output:
> > >
> > > tail /sys/block/md2/queue/discard_*
> > 
> > # tail /sys/block/md2/queue/discard_*
> > ==> /sys/block/md2/queue/discard_granularity <==
> > 4096
> > 
> > ==> /sys/block/md2/queue/discard_max_bytes <==
> > 2147450880
> > 
> > ==> /sys/block/md2/queue/discard_max_hw_bytes <==
> > 2147450880
> > 
> > ==> /sys/block/md2/queue/discard_zeroes_data <==
> > 0

Sebastian, 

This could be an upstream problem.  For now you could disable discards.  
One to do this might be to place the cache device under LVM and set 
issue_discards=0 in lvm.conf.  Then register the LV as your cachedev. 
Hopefully this is an initial use case and that you don't have important 
writeback data in the cache such that you can re-create it.  We use LVM to 
allocate our cache volumes so I know it works.

I'm not sure if /sys/block/md2/queue/discard_granularity is writable, but 
if it is, you could `echo 0 > /sys/block/md2/queue/discard_granularity` 
which should disable discard too.

Perhaps others can chime in on turning off discard support for block 
devices if there is a better way, perhaps even something md-specific.


--
Eric Wheeler



> > 
> > root@gropius:/home/sroesner# echo /dev/md2 > /sys/fs/bcache/register
> > sroesner@gropius:~$
> > 
> > -> it killed my bash.
> > 
> > Trace with patches and BUG_ON patch:
> > 
> > [  172.660142] BUG: unable to handle kernel NULL pointer dereference at
> > 0000000000000028
> > [  172.660229] IP: [<ffffffff811e53b4>] bio_trim+0xf/0x2a
> > [  172.660289] PGD 7faf3e067 PUD 7f9279067 PMD 0
> > [  172.660399] Oops: 0000 [#1] SMP
> > [...]
> > [  172.664780] Call Trace:
> > [  172.664813]  [<ffffffffa007f3be>] ? raid1_make_request+0x2e8/0xad7 [raid1]
> > [  172.664846]  [<ffffffff811f07da>] ? blk_queue_split+0x377/0x3d4
> > [  172.664880]  [<ffffffffa005fb5f>] ? md_make_request+0xf6/0x1e9 [md_mod]
> > [  172.664912]  [<ffffffff811eb860>] ? generic_make_request+0xb5/0x155
> > [  172.664947]  [<ffffffffa0445c89>] ? prio_io+0x85/0x95 [bcache]
> > [  172.664981]  [<ffffffffa0448252>] ? register_cache_set+0x355/0x8d0 [bcache]
> > [  172.665016]  [<ffffffffa04497d3>] ? register_bcache+0x1006/0x1174 [bcache]
> > 
> > See http://pastebin.com/6CHtky2x for complete traces.
> > 
> > Sebastian
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
