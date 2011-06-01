From: Pol Hallen <raid2@fuckaround.org>
Subject: Raid1 info (not active degraded raid)
Date: Wed, 1 Jun 2011 18:32:51 +0200
Message-ID: <201106011832.51688.raid2@fuckaround.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi folks :-)

I build a raid1 with mdadm. For purpose test I disconnected a disk and raid1 
runs perfectly.

After reboot /dev/md1 (raid1) doesn't appear by cat /proc/mdstat

(I have also a raid6 on /dev/md0)

mdadm -E /dev/sdh (a disk of raid1) show me correct raid

How I start this raid?

raid6 works so mdadm runs.

thanks and sorry for my bad english :-@
 
Pol
