From: Marc Smith <msmith626@gmail.com>
Subject: MD Array 'stat' File - Sectors Read
Date: Mon, 30 Mar 2020 16:54:16 -0400
Message-ID: <CAH6h+heYBA5RvBH7GPJ6JkPUYvjxT2A4f_gBVs=Pr-ps6rPRQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

Apologies in advance, as I'm sure this question has been asked many
times and there is a standard answer, but I can't seem to find it on
forums or this mailing list.

I've always observed this behavior using 'iostat', when looking at
READ throughput numbers, the value is about 4 times more than the real
throughput number. Knowing this, I typically look at the member
devices to determine what throughput is actually being achieved (or
from the application driving the I/O).

Looking at the sectors read field in the 'stat' file for an MD array
block device:
# cat /sys/block/md127/stat && sleep 1 && cat /sys/block/md127/stat
93591416        0 55082801792        0       93        0        0
  0        0        0        0        0        0        0        0
93608938        0 55092996456        0       93        0        0
  0        0        0        0        0        0        0        0

55092996456 - 55082801792 = 10194664
10194664 * 512 = 5219667968
5219667968 / 1024 / 1024 = 4977

This device definitely isn't doing 4,977 MiB/s. So now my curiosity is
getting to me: Is this just known/expected behavior for the MD array
block devices? The numbers for WRITE sectors is always accurate as far
as I can tell. Or something configured strangely on my systems?

I'm using vanilla Linux 5.4.12.


Thanks,

Marc
