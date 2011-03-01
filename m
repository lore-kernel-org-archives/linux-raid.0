From: "Jansen, Frank" <fjansen@CROSSBEAMSYS.COM>
Subject: Latency issues with MD-RAID
Date: Tue, 1 Mar 2011 21:13:46 +0000
Message-ID: <FE279AF0CA06284B8C26150408F3EB12078DB4AA@CBSSEXM02P.crossbeamsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

We're doing some testing to determine performance of MD-RAID and suitability for our environment.

One particular test is giving some cause for concern:

- Run heavy I/O to a raw partition:
 # time dd if=/dev/zero of=/dev/md0p1 bs=131072 count=1000000
- Run single sync I/Os to the partition:
 # time dd if=/dev/zero of=/dev/md0p1 bs=4096 count=1 oflag=sync

When we run this, latency for the single I/O completion can go as high as 5-10 seconds

In investigating this, it looks like the following code in md_write_start causes most of the slow down:

        if (mddev->in_sync) {
                spin_lock_irq(&mddev->write_lock);
                if (mddev->in_sync) {
                        mddev->in_sync = 0;
                        set_bit(MD_CHANGE_CLEAN, &mddev->flags);
                        set_bit(MD_CHANGE_PENDING, &mddev->flags);
                        md_wakeup_thread(mddev->thread);
                        did_change = 1;
                }
                spin_unlock_irq(&mddev->write_lock);
        }

When we change this to run about once every 10 seconds, our latency goes way down to a reasonable number of milliseconds.

Questions:
- is the high latency for single sync I/Os something that we should expect?
- the first time the thread runs, it was seen to take a lot longer.  Is this due to more outstanding metadata or similar?
- is the approach to run the thread less frequently reasonable, or does that open up huge problems?

Thanks,

Frank
