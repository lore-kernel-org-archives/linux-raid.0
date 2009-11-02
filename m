From: Chris Worley <worleys@gmail.com>
Subject: Unbelievably _good_ write performance: RHEL5.4 mirror
Date: Mon, 2 Nov 2009 11:28:10 -0700
Message-ID: <f3177b9e0911021028t1fea4ad2lb4cf87059d300a0c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linuxraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I expect RAID1 write performance to be, at best, the performance of
the slowest drive.

I'm seeing twice the performance, as if it were a RAID0.  The read
performance is 2x also, which is what I would expect.

I'm using the incantation:

mdadm --create /dev/md0 --chunk=256 --level=1 --assume-clean
--raid-devices=2 /dev/sd[bc]

I use "assume clean" on the fresh create, as there is no reason to
sync the new drives.

My "fio" test uses O_DIRECT with 64 threads, each with a queue depth
of 64, running for 10 minutes.  All caching is disabled, and the NOOP
scheduler is being used.  I run this test all the time, and can't
imagine why it's getting such repeatably good write performance.

Any ideas?

Thanks,

Chris
