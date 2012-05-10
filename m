From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Data Offset
Date: Thu, 10 May 2012 19:42:10 +0200
Message-ID: <20120510174210.GA2991@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

after the RAID-5 problem, I just realized that
other RAIDs I have, including a multi RAID-6,
have different data offset for each component.

This seems to be quite of a problem, in case
"Create" is used to recover an array.

Obviouly, if a 4 disks RAID-5 has 2 disks with
one offset and 2 with another, it will not be
possible to re-create it (saving the data).

Is there any way to fix/prevent such issue?
Shouldn't "mdadm" make sure all offset are
the same? Or try, at least...

What I noticed is that, adding a disk later,
might cause different offsets.

Any idea?

Thanks,

bye,

-- 

piergiorgio
