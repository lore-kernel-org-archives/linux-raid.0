From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Bad raid0 bio too large problem
Date: Tue, 22 Sep 2015 11:30:53 -0400
Message-ID: <wrfjoagucvyq.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Xiao Ni <xni@redhat.com>, linux-raid <linux-raid@vger.kernel.org>, yizhan@redhat.com
List-Id: linux-raid.ids

Hi Neil,

I think we have some bad side effects with this patch:

commit 199dc6ed5179251fa6158a461499c24bdd99c836
Author: NeilBrown <neilb@suse.com>
Date:   Mon Aug 3 13:11:47 2015 +1000

    md/raid0: update queue parameter in a safer location.
    
    When a (e.g.) RAID5 array is reshaped to RAID0, the updating
    of queue parameters (e.g. max number of sectors per bio) is
    done in the wrong place.
    It should be part of ->run, but it is actually part of ->takeover.
    This means it happens before level_store() calls:
    
        blk_set_stacking_limits(&mddev->queue->limits);
    
Running the '03r0assem' test suite fills my kernel log with output like
below. Yi Zhang also had issues where writes failed too.

robably something we need to resolve for 4.2-final or revert the
offending patch.

Cheers,
Jes

md: bind<loop0>
md: bind<loop1>
md: bind<loop2>
md/raid0:md2: md_size is 116736 sectors.
md: RAID0 configuration for md2 - 1 zone
md: zone0=[loop0/loop1/loop2]
      zone-offset=         0KB, device-offset=         0KB, size=     58368KB

md2: detected capacity change from 0 to 59768832
bio too big device loop0 (296 > 255)
bio too big device loop0 (272 > 255)
bio too big device loop1 (672 > 255)
bio too big device loop1 (352 > 255)
bio too big device loop2 (1024 > 255)
bio too big device loop0 (672 > 255)
bio too big device loop1 (256 > 255)
bio too big device loop2 (288 > 255)
bio too big device loop2 (736 > 255)
bio too big device loop0 (288 > 255)
bio too big device loop2 (256 > 255)
bio too big device loop2 (368 > 255)
bio too big device loop0 (488 > 255)
bio too big device loop0 (360 > 255)
bio too big device loop0 (256 > 255)
bio too big device loop1 (288 > 255)
bio too big device loop1 (736 > 255)
bio too big device loop2 (288 > 255)
bio too big device loop1 (256 > 255)
bio too big device loop1 (512 > 255)
bio too big device loop2 (856 > 255)
bio too big device loop2 (256 > 255)
bio too big device loop0 (288 > 255)
bio too big device loop0 (736 > 255)
bio too big device loop1 (288 > 255)
bio too big device loop0 (256 > 255)
bio too big device loop0 (512 > 255)
bio too big device loop1 (856 > 255)
bio too big device loop1 (256 > 255)
bio too big device loop2 (288 > 255)
bio too big device loop2 (736 > 255)
md2: detected capacity change from 59768832 to 0
md: md2 stopped.
