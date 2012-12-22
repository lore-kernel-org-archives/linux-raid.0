From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: recommended way to add ssd cache to mdraid array
Date: Fri, 21 Dec 2012 23:57:19 -0700
Message-ID: <201212212357.19292.thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'm setting up a new nas box (7x2TB on a IBM M1015 8 port sas card flashed to 
9211IT mode) and was thinking about adding an SSD cache to it. I've been 
following bcache's development, but it seems to have stalled a bit.

I've got a 240G Samsung 470/810 that I'd like to use for this.

Also I was wondering if anyone has any tips on the best (or their preferred) 
way to set up a "big" raid6 array with a single filesystem. I'm probably going 
to stick with XFS, but I'm not married to it, if there's something better for 
a big media (audio, video, disk images, backups, etc) volume I'd love to hear 
about it.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
