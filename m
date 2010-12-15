From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: raid1 module is not ready to take IO request
Date: Wed, 15 Dec 2010 17:23:56 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D176B3CE2F@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "neilb@suse.de" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

Hi Neil,
We have spotted that when RAID 1 array is assembled and stopped in a loop, there is an occasional kernel oops in raid1 module.
It occurs in make_request function on wait_barrier(conf). In this case mddev->private was NULL, since probably it was not yet initialized in run() function.
The straightforward approach is test for mdadm->private and return bio_endio with an error if private not set.
The question is:
Since raid1 module might receive IO request when it is not ready, what make_request can check for to test if for instance run() function has finished.

Thanks,
Marcin Labun
