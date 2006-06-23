From: Pete Zaitcev <zaitcev@redhat.com>
Subject: Curious code in autostart_array
Date: Thu, 22 Jun 2006 21:05:21 -0700
Message-ID: <20060622210521.0aa68ec6.zaitcev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: mingo@redhat.com, dledford@redhat.com, zaitcev@redhat.com
List-Id: linux-raid.ids

Hi, guys:

My copy of 2.6.17-rc5 has the following code in autostart_array():
		mdp_disk_t *desc = sb->disks + i;
		dev_t dev = MKDEV(desc->major, desc->minor);

		if (!dev)
			continue;
		if (dev == startdev)
			continue;
		if (MAJOR(dev) != desc->major || MINOR(dev) != desc->minor)
			continue;

Under what conditions do you think the last if() statement can fire?
What is its purpose? This looks like an attempt to detect bit clipping.
But what exactly?

Cheers,
-- Pete
