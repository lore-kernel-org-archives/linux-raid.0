From: Mario Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: RAID1: no resync after crash?
Date: Fri, 18 Mar 2005 14:08:14 +0100
Message-ID: <d1ejor$9j7$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I'm running several 3-mirror-RAID1s in degraded mode (2 out of 3
mirrors operational) on a 2.4.27 (Debian's kernel-source-2.4.27).

The machine crashed sometimes in the past and I was always
wondering why the mirrors got not resynched after startup.
I always did compare the mirrors and they had only 4 different
octets near the end of the devices which I consider as normal
superblock differences. Therefore, I assumed the resync not
happening intentional.
However, I had a crash yesterday with no resync happenig again
but comparing the mirrors showed up some more differences than
just the 4 at the end. So I'm wondering if the missing resync
is *really* intentional.

Is there perhaps some bug that denies a resync on a degraded
RAID1 even if there is more than one mirror operational?

As I said - I'm running 2.4.27, so I have none of the new 2.6
features like superblocks marked clean while runtime and things
like that.


regards
   Mario
-- 
[mod_nessus for iauth]
<delta> "scanning your system...found depreciated OS...found
        hole...installing new OS...please reboot and reconnect now"

