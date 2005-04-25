From: Anu Matthew <anu.matthew@bms.com>
Subject: Does mdadm work on active/passive arrays
Date: Mon, 25 Apr 2005 16:29:39 -0400
Message-ID: <426D5333.4080502@bms.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Just a small question about creating multipath devices using mdadm:

Does it support Active/Passive Arrays like the Clariion?

I am using mdadm  v1.11.0, and the devices return no UUID when queried 
using mdadm -D --scan.

dmesg has a lots of entries like:

md: write_disk_sb failed for device sdf
md: errors occurred during superblock update, repeating
Device 08:50 not ready.

BTW, I am using qla2300 modules with options scsi_mod max_scsi_luns=255 
scsi_allow_ghost_devices=1.

Thanks in advance,

--AM
