From: Tomasz Rostanski <Tomasz.ROSTANSKI@thalesgroup.com.pl>
Subject: mdadm: Intel RST option ROM not found when Video option ROM is
 disabled
Date: Mon, 17 Oct 2016 10:31:23 +0200
Message-ID: <ed347cfe-c879-0981-8f00-4f6e96c5ff6e@thalesgroup.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The mdadm assumes the Video ROM is present in the system (0xc0000 ~ 
0xc7fff), so the it scans the other option ROMs (including Intel RST 
option ROM) starting from address 0xc8000 to 0xfffff.

If Video ROM is absent, the other option ROMs will start from 0xc0000. 
In my case, the Intel RST option ROM is located at Video ROM area, and 
mdadm is not finding it. The find_imsm_hba_orom() returns NULL.

Due to the changes introduced in mdadm 3.3.4 (commits 7eee461 “Assemble: 
don’t assemble IMSM array without OROM.” and 8360760 “Assemble: really 
don’t assemble IMSM array without OROM.”) the mdadm is reporting the 
Intel RAID is not supported on my platform.


Regards,

Tomasz


