From: "Daniel L. Miller" <dmiller@amfes.com>
Subject: Grow a RAID-10
Date: Wed, 02 Jul 2008 14:56:04 -0700
Message-ID: <486BF974.70508@amfes.com>
Reply-To: dmiller@amfes.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I currently have a RAID10 across (4) SATA drives.  It looks like I'm 
going to need to grow in the near future.  Any tips for a procedure for 
this?  My current plan:

1.  Add a PCI SATA controller (MB had 4 SATA + 4 RAID SATA, it's a Tyan 
MB with a NFORCE chipset, I'm not sure if I want/can use the RAID SATA 
ports as plain SATA connections).

2.  Add 2 more drives - not necessarily the same size as the existing 
(they were all 4 the same)

3.  Execute "mdadm --grow /dev/md0"

-- 
Daniel
