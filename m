From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: syncing RAID1 with more than 10MB/sec
Date: Wed, 30 Mar 2005 04:40:43 -0500
Message-ID: <200503300940.j2U9enm06046@www.watkins-home.com>
References: <424A6D99.6070501@netuse.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <424A6D99.6070501@netuse.de>
Sender: linux-raid-owner@vger.kernel.org
To: 'Nils-Henner Krueger' <nhk@netuse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Nils-Henner Krueger
> Sent: Wednesday, March 30, 2005 4:13 AM
> To: linux-raid@vger.kernel.org
> Subject: syncing RAID1 with more than 10MB/sec
> 
> Syncing a raid1 takes long time for large disks because of
> the 10MB/sec limit:
> 
> Mar 30 10:58:31 imap1 kernel: raid1: raid set md2 not clean;
> reconstructing mirrors
> Mar 30 10:58:31 imap1 kernel: raid1: raid set md2 active with 2 out of 2
> mirrors
> Mar 30 10:58:31 imap1 kernel: md: syncing RAID array md2
> Mar 30 10:58:31 imap1 kernel: md: minimum _guaranteed_ reconstruction
> speed: 100 KB/sec/disc.
> Mar 30 10:58:31 imap1 kernel: md: using maximum available idle IO
> bandwith (but not more than 10000 KB/sec) for reconstruction.
> 
> Is it possible to raise this value (without recompiling)?
> I know about possible performance tradeoffs with other
> processes, I'm just generally interested.
> 
> Thanks.
> 
> nils-henner

Yes.  For details:
man md

The default of 10,000 has been increased to 100,000 in newer kernels.
I don't know which kernels.

If you want to override the defaults you could add these 3 lines to
/etc/sysctl.conf:
# RAID rebuild min/max speed K/Sec per device
dev.raid.speed_limit_min = 1000
dev.raid.speed_limit_max = 100000

Adjust above as required.  The above will take effect after a reboot.

To see current values type these 2 lines:
cat /proc/sys/dev/raid/speed_limit_min
cat /proc/sys/dev/raid/speed_limit_max

To temporarily change the defaults use these 2 commands:
echo 1000 > /proc/sys/dev/raid/speed_limit_min
echo 100000 > /proc/sys/dev/raid/speed_limit_max

Adjust above as required.  The above will take effect now.

Guy

