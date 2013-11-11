From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: recommending RAID6 over RAID5 when doing mdadm --create
Date: Mon, 11 Nov 2013 08:44:03 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1311110841340.26054@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi,

I believe this has been discussed before, but I would like to bring it up 
again.

I would like to see mdadm recommend RAID6 over RAID6 when using component 
drives that are 500GB or larger and ask if the user is really sure about 
using RAID5, plus a pointer to a webpage on the wiki informing the user 
about the trouble with RAID5 on large volumes with consumer or prosumer 
drives.

I am willing to contribute text to the webpage being pointed to.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
