From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: PAGE_SIZE=8K and bitmap
Date: Thu, 30 Aug 2007 21:44:26 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708302143170.24730@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,


a while back I reported a bug for 2.6.21 where creating an MD raid array 
with internal bitmap on a sparc64 system does not work. I have not yet 
heard back (or I forget); has this been addressed yet?
	(mdadm -C /dev/md0 -l 1 -n 2 -e 1.0 -b internal /dev/ram[01])


thanks,
	Jan
-- 
