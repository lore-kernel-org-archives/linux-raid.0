From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Use RAID-6!
Date: Wed, 17 Apr 2013 01:06:00 -0500
Message-ID: <516E3BC8.5080909@hardwarefreak.com>
References: <15345091.8.1366130671716.JavaMail.root@zimbra> <516DABF2.5050409@tigertech.com> <516DAF21.5040409@aei.mpg.de> <516DD433.50100@tigertech.com> <516DEAD4.7080305@bucksch.org> <516DFC4F.5000908@websitemanagers.com.au> <516E24C8.9080803@tigertech.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <516E24C8.9080803@tigertech.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert L Mathews <lists@tigertech.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 4/16/2013 11:27 PM, Robert L Mathews wrote:

> I avidly read the details of every RAID 5 [and 6] disaster on the list,
> and almost every one would be trivially easy to fix under RAID 1, with
> no risk of complete data loss. It's heartbreaking.

I do read most of them as well.  But mirrors simply don't scale in
either capacity or performance and thus aren't suitable.  If one needs a
4TB+ filesystem today or more than combined ~150MB/s streaming write
throughput one must use one of:

1.  RAID10
2.  RAID0 over RAID1 pairs/triples
3.  A linear concat over pairs/triples w/XFS
4.  RAID5 or RAID6

Each of these is most suitable for only subset of workloads, but all of
them can scale to more than 4TB, whereas RAID1 cannot.  When
SATA4/SAS1200 arrive offering 1.2GB/s interface rate, and SSDs hit 2-4TB
capacity at reasonable prices, then I think you'll see more straight
RAID1 being used in more of the systems that don't need any more total
capacity.  But as many servers will always need more than this and will
still use rust, striped/concatenated arrays will be with us for quite
some time.

And BTW, regarding your triplets setup, if you want to do that right
according to your philosophy, then you need a dedicated SAS/SATA
controller for each drive, each controller being of a different
make/model with different firmware.  The old UNIX/Netware "duplexing"
strategy but triplexing in this case.  But I doubt you're doing this.
All 3 are probably connected to the single motherboard down SATA
controller.

-- 
Stan

