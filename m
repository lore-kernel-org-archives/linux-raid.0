From: thomas62186218@aol.com
Subject: /sys/block/md0 still present after mdadm -S and -r
Date: Fri, 26 Sep 2008 09:28:56 -0400
Message-ID: <8CAEDF2F5FF1BF0-E4C-2919@WEBMAIL-MY17.sysops.aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, thomas62186218@aol.com
List-Id: linux-raid.ids

Hi All,

I created an md device as follows:

mdadm -C -f -e 1.0 -R /dev/md0 -l 0 -n 2 -c 32 /dev/sdc1 /dev/sdg1

It was successful and started.

I then want to delete this md device and did as follows:

mdadm -S /dev/md0
mdadm /dev/md0 -r
mdadm --zero-superblock /dev/sdc1
mdadm --zero-superblock /dev/sdg1

I did not receive any errors. Afterwards, md0 was no longer visible in 
/proc/mdstat.

However, there is still /sys/block/md0 entry, as well as an /dev/md0 
entry. I would have expected these to be gone.

Is my md0 not getting fully deleted?

Thanks!
Thomas
