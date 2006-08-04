From: "Francois Barre" <francois.barre@gmail.com>
Subject: Raid5 bitmap - Bug in bitmap_startwrite()
Date: Fri, 4 Aug 2006 11:05:15 +0200
Message-ID: <fd8d0180608040205i5db2453flaf797ae506f823a6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

I lost connection to the testing machine, so I'll have to recall all
the details. I may have contact with it again by tonight, so I may be
able to post exact problems.

The setup : ppc/g4 (mac mini) running 4 firewire-based raid5 disks.
Kernel 2.6.18-rc3 from linux/kernel/git/linville/wireless-dev.git

The action : on this 4 disk raid5, add an internal bitmap (mdadm -g
--bitmap internal) while the array is rebuilding

The problem : at bitmap insertion, kernel shows a BUG in
bitmap_startwrite() at line 1122 (as far as I recall). This is a bit
strange, because the only BUG_ON() defined in this function is at
1166, and is

  BUG_ON((*bmc & COUNTER_MAX) == COUNTER_MAX);

The running rebuild goes on, but at the end of it the machine hangs completely.
This bug has been triggered with a clean raid5 (i.e. not rebuilding)
also, and with 2.6.17-rc3.

The question : is the bitmap creation tested in such recent kernels ?
Including BE cpus ?
I may investigate the value of (*bmc), which is the result of
bitmap_get_counter().. Is the value only modified in
bitmap_startwrite() at line 1167 with (*bmc) ++; ?

Final question, I do not fully understand the bitmap_get_counter()
function, especially comparing the 'hijacked' version (lines
1126-11127) :
  return &((bitmap_counter_t *) &bitmap->bp[page].map)[hi];

and the 'normal' version (lines 1131-1132)
   return (bitmap_counter_t *) &(bitmap->bp[page].map[pageoff]);

The hijacked version uses a 16-bit bitmap_counter_t*
'bitmap->bp[page].map' table with the hi index, whereas the normal
uses a 8-bit char* 'bitmap->bp[page].map' table with the pageoff
index.

This may be the 'hijacked' logic, but I'm a little puzzled here.

Thanks for any clues, help, or... anything else.

Regards,
