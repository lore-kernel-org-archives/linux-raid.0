From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: RAID grow and disk failure
Date: Thu, 24 Jun 2010 20:12:13 +0200
Message-ID: <20100624181213.GB9038@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I was wondering, let's say a RAID-6 has an HDD
added and a grow is performed.

What will happen if one of the HDD of the RAID,
possibly the newly added, will faili, i.e. die?

Will the RAID continue the grow using all the
available parity or it will result in a
catastrophic failure for the array?

As side question, assuming the above RAID volume
is a PV (LVM physical volume), what would be the
correct procedure to grow it and extend the PV:

1)
mdadm --grow ...
mdadm --wait
pvresize

2)
mdadm --grow
pvresize

Thanks,

bye,

-- 

piergiorgio
