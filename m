From: celestar@t-online.de (Frank Victor Fischer)
Subject: Re: RAID5 (along with RAID1) locks up
Date: Mon, 10 May 2004 21:58:04 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200405102158.04419.celestar@t-online.de>
References: <200405101351.i4ADpYB03061@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200405101351.i4ADpYB03061@www.watkins-home.com>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

> I see your RAID1 (md0) using sda1, sdb1 and sdc1.
> Which disks/partitions is your RAID5 using?

Whoops that log was created before I re-created the RAID5

it was md1, using sda3, sdb3 and sdc3, each using up the rest of the drive.

Victor
