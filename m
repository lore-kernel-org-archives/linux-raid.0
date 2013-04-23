From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Incredibly poor performance of mdraid-1 with 2 SSD Samsung 840
 PRO
Date: Mon, 22 Apr 2013 23:39:38 -0500
Message-ID: <5176108A.5020506@hardwarefreak.com>
References: <5171CBF9.9020701@redhost.ro> <51732E2B.6090607@hardwarefreak.com> <5174501F.80509@redhost.ro> <51747382.1010105@hardwarefreak.com> <5175C388.2050500@redhost.ro>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5175C388.2050500@redhost.ro>
Sender: linux-raid-owner@vger.kernel.org
To: Andrei Banu <andrei.banu@redhost.ro>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/22/2013 6:11 PM, Andrei Banu wrote:
...
> 1. First test (bs=1G): same as always.
> root [~]# dd if=testfile.tar.gz of=test oflag=sync bs=1G
> 547682517 bytes (548 MB) copied, 53.3767 s, 10.3 MB/s
...
> root [~]# dd if=testfile.tar.gz of=test6 oflag=sync bs=4M
> 547682517 bytes (548 MB) copied, 116.469 s, 4.7 MB/s
...
> Again, I don't think my problem is related to any concurrent I/O
> starvation. These SSDs or this mdraid or I don't know what simply can't
> take any sustained write task. And this is not due to the server load.
> Even during very low server loads it's enough to write about 1GB of data
> within a short time frame (minutes) to bring the I/O system to it's
> knees for a considerable time (at least tens of minutes).

Something's going on here.  Ditch dd for now.  What's the result of:

$ echo 3 > /proc/sys/vm/drop_caches
$ time cp testfile.tar.gz testxx.tmp; sync
548/real = xx MB/s

And now ditch flushing FS buffers:
$ echo 3 > /proc/sys/vm/drop_caches
$ time cp testfile.tar.gz testxx.tmp
548/real = xx MB/s

And please paste this so we can see how you're mounting EXT4.
$ cat /etc/fstab |grep ext

Mounting data=journal will decrease write throughput by 50% as
everything is written twice: once to the journal, once into the
filesystem.  This wouldn't account for the entire performance deficit
though.

-- 
Stan

