From: Patrick Dung <mpatdung@gmail.com>
Subject: Is trim/discard supported on LVM RAID logical volume?
Date: Tue, 29 Nov 2016 20:59:38 +0800
Message-ID: <CAEtPA0ByX8yYx8xNc_=4SP0bqXVz-D4o-bM5XZF8Y6NcnqsEKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

Sorry if it is a cross posting.
I had post my question in linux-lvm mailing list but did not have reply.

In my old setting, fstrim is supported:
ext4 over LVM over MD software raid 1 (mdadm) > SSD.

After reading the recommendation in RHEL 6
https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Storage_Administration_Guide/ch-ssd.html

I changed to use raid 1 mirror using 'LVM RAID logical volume'. It
make use of MD raid internally.
But I found fstrim does not work anymore. Is the behavior expected?

Thanks and regards,
Patrick
