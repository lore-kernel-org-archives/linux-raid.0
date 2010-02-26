From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Device role question
Date: Fri, 26 Feb 2010 15:23:31 +0100
Message-ID: <20100226142331.GA2328@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

checking randomly the component of some RAID-10 arrays
(two disks each), with "mdadm -E /dev/sdXY", I noticed
the following.

There is an entry reported, called "Device Role".

On one array, the components are defined, respectively, as:

Active device 0
Active device 1

On another two arrays, it's a bit different.

Active device 0
spare

Why is it "spare" (all are RAID-10 f2)?

Does it make any difference one or the other role, in
this type of RAID?

On the other hand, "mdadm -D /dev/mdX" does not seem
to give any hint on the different roles.

Thanks,

bye,

-- 

piergiorgio
