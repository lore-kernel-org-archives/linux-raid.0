From: Ian Pilcher <arequipeno@gmail.com>
Subject: RAID types & chunks sizes for new NAS drives
Date: Sun, 21 Jun 2020 11:23:35 -0500
Message-ID: <rco1i8$1l34$1@ciao.gmane.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm replacing the drives in my 5-bay NAS, and planning how I'm going to
divide them up.  My general plan is to create a matching set of
partitions on the drives, and then create RAID devices across the sets
of partitions, for example:

   md1:  /dev/sdb1  /dev/sdc1  /dev/sdd1  /dev/sde1  /dev/sdf1
   md2:  /dev/sdb2  /dev/sdc2  /dev/sdd2  /dev/sde2  /dev/sdf2
    ⋮         ⋮          ⋮          ⋮          ⋮          ⋮
   md16: /dev/sdb16 /dev/sdc16 /dev/sdd16 /dev/sde16 /dev/sdf16

This will give me the flexibility to create RAID devices of different
types, as well as maybe(?) reducing the "blast radius" if a particular
portion of a disk goes bad.

I believe that it makes sense to use at least 2 different RAID levels -
RAID-10 for "general" use and RAID-6 for media content.  Does this make
sense?

If so, does anyone have any thoughts or pointers on the chunk size,
particularly for RAID-10?  (I assume that RAID-6 will have similar
considerations to RAID-5, and so a large chunk size would make sense,
particularly for large media files.)

Any other thoughts?

Thanks!

-- 
========================================================================
                  In Soviet Russia, Google searches you!
========================================================================
