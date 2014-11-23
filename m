From: Henry Cai <henryplusplus@gmail.com>
Subject: MD RAID5 hang on make_request
Date: Sun, 23 Nov 2014 09:08:55 +0800
Message-ID: <CANH1pmsL4dHvsmkj52=jpWGQmx5B39hY3w480pkJs7ZmKnpptg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

With kernel-3.10, when raid5 is doing resync, unplug one of the
raid5's disk, RAID5 will hang on raid5's make_request function, and
cat /proc/mdstat show the RAID "resync=PENDING", mdadm version is
3.3.2. The platform is arm.

Any similar problems?
