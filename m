From: Anu Matthew <anu.matthew@bms.com>
Subject: monitoring multipath arrays plus inconsistent /proc/mdstat?
Date: Thu, 21 Oct 2004 12:16:17 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4177E0D1.7090001@bms.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

mdadm --monitor or mdadm --follow does not report anything if a link to 
my multipath array fails, which makes sense at times. (?)

On rhel 2.1 at least, sometimes I have seen that /proc/mdstat is not 
consistent as in this case, it has marked /dev/sdi as failed, where as 
mdadm -D on md3 has reported both links to be active, and in fact is 
using the "failed link" in mdstat as the active path..!!

------------------from /proc/mdstat---------------------------------------
md3 : active multipath sdd[1] sdi[0](F)

----------------from mdadm o/p--------------------------
[root@tlr root]# mdadm -D /dev/md3
/dev/md3:
<snip>
<snip>
    Number   Major   Minor   RaidDevice State
       0       8      128        0      active sync   /dev/sdi

       1       8       48        1      spare   /dev/sdd

----------------------------------------------------------------------------

Whom to trust here? How do we monitor multipath arrays effectively?

--Matt
