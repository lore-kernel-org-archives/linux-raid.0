From: Pavel Herrmann <morpheus.ibis@gmail.com>
Subject: data corruption after rebuild
Date: Tue, 19 Jul 2011 15:55:35 +0200
Message-ID: <2073005.NH8LALaxuD@bloomfield>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have a big problem with mdadm, I removed a drive from my raid6, after 
replacing it the raid started an online resync. I accidentally pushed the 
computer and it shut down (power cord moved), and after booting it again the 
online resync continued.

the problem is that the rebuilt array is corrupted. most of the data is fine, 
but every several MB there is an error (which doesn't look like being caused 
by a crash), effectively invalidating all data on the drive (about 7TB, mainly 
HD video)

I do monthly scans, so the redundancy syndromes should have been up-to-date, 
the array is made of 8 disks, the setup is ext4 on lvm on mdraid

is there anything to solve this? or at least ideas what happened?
