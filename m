From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: RAID-5 and Chunk Size, What Filesystem to Use?
Date: Sun, 30 Mar 2003 23:03:20 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E87BE08.42E9964@SteelEye.com>
References: <b68cso$ogh$1@main.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Jon Robertson <jonrobertson@sbcglobal.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jon Robertson wrote:
> 
> I've been reading the Jakob Oostergard article...and it's amazing how easy
> this can be, however I may have been typing too fast....
> 
> I have 3 SCSI that are 36GB each and I created my raidtab to look like the
> following:
> 
> raid-level                     5
> chunk-size                   128
> persistent-superblock   1
> parity-algorithm            left-symmetric
> nr-raid-disks                3
> device                          /dev/sda
> raid-disk                    0
> device                          /dev/sda
> raid-disk                    1

Ermm...you didn't actually intend to have sda be both raid disks 0 and
1, did you?

--
Paul
