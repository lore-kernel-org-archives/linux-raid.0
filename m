From: Marcin Krol <admin@domeny.pl>
Subject: Re: Deleting mdadm RAID arrays
Date: Wed, 6 Feb 2008 12:56:32 +0100
Message-ID: <200802061256.32378.admin@domeny.pl>
References: <200802051142.19625.admin@domeny.pl> <47A99858.70103@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47A99858.70103@dgreaves.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Wednesday 06 February 2008 12:22:00:
> > I have had a problem with RAID array (udev messed up disk names, I've had RAID on
> > disks only, without raid partitions)
> 
> Do you mean that you originally used /dev/sdb for the RAID array? And now you
> are using /dev/sdb1?

That's reconfigured now, it doesn't matter (started up the host in single user, created
partitions as opposed to running RAID previously on whole disks).
 
> Given the system seems confused I wonder if this may be relevant?

I don't think so, I tried most mdadm operations (fail, remove, etc) on disks (like sdb) and 
partitions (like sdb1) and get identical messages for either.


-- 
Marcin Krol

