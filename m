From: Ferenc-Jan <ferenc@avz.xs4all.nl>
Subject: mdadm -D /dev/md3: 1  0  0  0  sync ???
Date: Wed, 22 Dec 2004 20:52:42 +0100
Message-ID: <41C9D08A.5080303@avz.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello list,

Does anybody know what this means:

# mdadm -D /dev/md3
<snip>
     Number   Major   Minor   RaidDevice State
        0       3        6        0      active sync   /dev/hda6
        1       0        0        0      sync

        2      22        6        2      active sync   /dev/hdc6

Please help. Which disk is '1  0  0  0  sync'? The array is currently 
degraded. How do I remove number 1 and bring number 2 up?

thanks in advance

Ferenc

