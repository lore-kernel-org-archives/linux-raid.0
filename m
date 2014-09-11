From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Status of discard support in MD RAID
Date: Thu, 11 Sep 2014 18:38:11 -0500
Message-ID: <1ED0286A-56DA-491D-853A-1C1045449201@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Neil (or anyone else),

I know that trim/discard support was added back in 2012 (commit 9db90880).  However, I thought there were still issues regarding what happens when various sync operations occur.  I'd like to turn on discard support in dm-raid.c (a oneline patch) if things are in order.  I can enable any, all or none depending on your recommendation.  (I assume RAID1/10 is easier than the parity RAIDs.)

Thanks for any information,
 brassow