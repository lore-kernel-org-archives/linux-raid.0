From: Hermann Himmelbauer <dusty@strike.wu-wien.ac.at>
Subject: Swap on RAID1?
Date: Tue, 14 Oct 2003 00:12:33 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200310140012.33121.dusty@strike.wu-wien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,
I am considering putting my Swap on a RAID1.

I am aware that using 2 seperate Swap-Spaces without RAID would probably speed 
things up as Linux distributes the swap.

But what happens if a disk fails and the swap is on this disk? I assume Linux 
would crash? Wouldn't a swap on a RAID prevent such a crash?

		Best Regards,
		Hermann

-- 
x1@aon.at
GPG key ID: 299893C7 (on keyservers)
FP: 0124 2584 8809 EF2A DBF9  4902 64B4 D16B 2998 93C7

