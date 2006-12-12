From: "liyiming" <liyiming@nrchpc.ac.cn>
Subject: Does the md codes can work well under SMP?
Date: Tue, 12 Dec 2006 15:23:59 +0800
Message-ID: <200612121523597963092@nrchpc.ac.cn>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


These days I devoted to reading md codes in 2.6.12_r11
I have noticed that you applied two different locking strategy in these two functions:
end_read_request:
	if (uptodate) {
		set_bit(R5_UPTODATE, &sh->dev[i].flags);	
	} else {
		md_error(conf->mddev, conf->disks[i].rdev);
		clear_bit(R5_UPTODATE, &sh->dev[i].flags);
	}
	rdev_dec_pending(conf->disks[i].rdev, conf->mddev);
	clear_bit(R5_LOCKED, &sh->dev[i].flags);
	set_bit(STRIPE_HANDLE, &sh->state);
	release_stripe(sh);
end_write_request:
	spin_lock_irqsave(&conf->device_lock, flags);
	if (!uptodate)
		md_error(conf->mddev, conf->disks[i].rdev);

	rdev_dec_pending(conf->disks[i].rdev, conf->mddev);
	
	clear_bit(R5_LOCKED, &sh->dev[i].flags);
	set_bit(STRIPE_HANDLE, &sh->state);
	__release_stripe(conf, sh);
	spin_unlock_irqrestore(&conf->device_lock, flags);


if these two function excuting on different CPU, the spin lock can work well? and why?
 				
--------------
liyiming
2006-12-12

