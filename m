From: jes.sorensen@gmail.com
Subject: Can we deprecate ioctl(RAID_VERSION)?
Date: Wed, 05 Apr 2017 13:55:34 -0400
Message-ID: <wrfjvaqid9ih.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,

Looking through the code in mdadm, I noticed a number of cases calling
ioctl(RAID_VERSION). At first I had it confused with metadata version,
but it looks like RAID_VERSION will always return 90000 if it's a valid
raid device.

In the cases we want to confirm the fd is a valid raid array,
ioctl(GET_ARRAY_INFO) should do, or sysfs_read(GET_VERSION).

Am I missing something obvious here, or do you see any reason for
leaving this around?

Thanks,
Jes
