From: Maurice Hilarius <maurice@harddata.com>
Subject: Awful RAID5 random read performance
Date: Sat, 30 May 2009 15:46:32 -0600
Message-ID: <4A21A938.6050907@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

A friend writes:

On a recent machine set up with Raid5.
On a AMD Phenom II X4 810, and 4GB ram.
4 Seagate 7200.12  SATA 1TB drives,

I'm getting some rather impressive numbers for sequential read
(300MB/s+) and write (170MB/s+) but the random read is proving to be
absolutely atrocious.
iostat says its going at about 0.5MB/s,

I've seen plenty of references to people getting numbers in the double 
digits
for random reads on a md raid5 array, and one with slower disks to boot.

I tried disabling automatic acoustic management on the drives, but it 
didn't
seem to help at all.
 I really don't care that much about the noise coming from a file server 
stuck in a closet  ;)

Does anyone know why I'm seeing such bad random read times?
There's got to be some configuration error on my part, but I just can't
seem to find what it might be.

I've spent a few hours on google looking for various tweaks but
almost nobody even mentions random read/write times.
All everyone seems to care about is block sequential access time.
I'd be willing to sacrifice a fair portion of  my rather excellent 
sequential
times for much better random access.

-- 
Regards, Maurice
