From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: standard performance (write speed 20Mb/s)
Date: Sat, 16 Jul 2011 23:26:12 -0500
Message-ID: <4E226464.2030200@hardwarefreak.com>
References: <201107162140.58883.raid1@fuckaround.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201107162140.58883.raid1@fuckaround.org>
Sender: linux-raid-owner@vger.kernel.org
To: Pol Hallen <raid1@fuckaround.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7/16/2011 2:40 PM, Pol Hallen wrote:
> Hi folks :-)
> 
> after assembled a new hw (xeon, ich10 controller with 5 disks of 2Tb wd - 
> radi5) I have slow write performance:
> 
> 20Mb/s :-(((
> 
> dd if=/dev/zero of=/share/raid/1Gb bs=1024M count=1
> 1+0 records in
> 1+0 records out
> 1073741824 bytes (1.1 GB) copied, 48.7203 s, 22.0 MB/s

Using a write block size of 1GB with dd causes the entire file to be
buffered to RAM before being flushed to disk.  To prove the point, I
just ran your test against a single SATA disk with an XFS filesystem.
XFS is is optimized for large files.

$ dd if=/dev/zero of=./test bs=1024M count=1
1+0 records in
1+0 records out
1073741824 bytes (1.1 GB) copied, 139.895 s, 7.7 MB/s

The same test using a *sane* block size of 4KB:

$ dd if=/dev/zero of=./test bs=4096 count=262144
262144+0 records in
262144+0 records out
1073741824 bytes (1.1 GB) copied, 15.0732 s, 71.2 MB/s

10x decrease in performance due to the insane 1GB block size.

The machine I ran this test on is old, having only 384MB RAM and a
Sil3512 PCI SATA-I controller.  The disk is a WD Blue 500GB 7.2K.  Using
the 1GB block size ate over 800MB of swap out of 1GB before the buffer
was flushed.  This massive buffering is what murders performance here.
Repeat your test using a 4KB block size and post the results.

Know your tools Pol.

-- 
Stan
