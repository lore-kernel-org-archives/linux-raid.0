From: Luke Reeves <luke@neuro-tech.net>
Subject: Adding a new mirror disk to RAID1 configuration
Date: Fri, 09 Jul 2004 12:54:52 +0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40EE251C.3060903@neuro-tech.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a system with two 40GB drives, and the first drive (hda) is setup 
  under an md device with RAID1 driving it.  I'm trying to now make the 
second disk, hdc, a mirror of the first.  When I try to add it using 
mdadm the second disk becomes a spare and no synchronization is done. 
Is there any way to add the second disk directly as a mirror?  Thanks.

	Luke Reeves
	http://www.neuro-tech.net/
