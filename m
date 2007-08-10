From: Neil Brown <neilb@suse.de>
Subject: Re: Another RAID level migration question
Date: Fri, 10 Aug 2007 11:55:45 +1000
Message-ID: <18107.50593.330335.913673@notabene.brown>
References: <46BB8B32.9010007@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Davidsen on Thursday August 9
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday August 9, davidsen@tmr.com wrote:
> I have an array on two drives which was set up as a RAID-0, because I 
> needed the space and performance. Now I have another identical drive, 
> ideally I would like to get to RAID-5, but I don't think that is going 
> to fly, so how about RAID-4? I could create with a missing parity drive, 
> then add the drive and see if it will rebuild.
> 
> I hope to test this using loop devices, but time is fairly short right now.

Providing the two drives are exactly the same size (which rounded down
to a multiple of 64K), this  will work.  The parity drive is the last
in the list so
   mdadm -C /dev/mdX -l4 -n3 -c WHATEVER /dev/sda1 /dev/sdb1 missing

is the sort of thing you want.

NeilBrown
