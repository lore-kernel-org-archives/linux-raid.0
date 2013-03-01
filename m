From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Periodically scanning RAID arrays for inconsistencies
Date: Fri, 1 Mar 2013 15:50:05 -0600
Message-ID: <81526C3C-7F95-4A17-B91B-8FD45BED55DE@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
Cc: NeilBrown <neilb@suse.de>, Jonathan Brassow <jbrassow@redhat.com>
List-Id: linux-raid.ids

Is there a way to periodically scan a RAID array to report any discrepancies?  This would be something like the initial synchronization, but would do nothing but report anomalies.  For example, it is possible for tracks to be altered when adjacent tracks are repeatedly written.  It might happen rarely, but without a periodic scan, you would never know about it.  Leaving aside the question of /what/ to do when an anomaly is found, I haven't seen any code or indication in the man page for 'mdadm' that would suggest this is currently possible.  Am I wrong?  Is there a way to do this?

 brassow

