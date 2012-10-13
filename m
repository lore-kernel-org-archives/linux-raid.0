From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: RAID-6 problem
Date: Sat, 13 Oct 2012 14:03:28 +0200
Message-ID: <20121013120328.GA23279@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I've a RAID-6, 10 HDDs, which, due to some hardware issue,
has lost 4 HDDs.
The RAID cannot be assembled anymore, of course.

The missing HDDs are now available and sane, so I guess it
could be possible to force an assemble operation.

What would be the reccomended way to proceed?

mdadm -A /dev/md1xx --force -c mdadm.conf

and then re-add the missing HDDs (does the above works?)

Or to re-create the array with "assume-clean" and with
the proper device order? The device role seems to be
available using "mdadm -E /dev/sdXy", I assume this
gives the proper order.

Thanks a lot in advance,

bye,

-- 

piergiorgio
