From: plug bert <plugbert@yahoo.com>
Subject: metadata versions: 0.90 vs 1.2
Date: Wed, 13 Jun 2012 12:55:43 +0800 (SGT)
Message-ID: <1339563343.41566.YahooMailClassic@web190003.mail.sg3.yahoo.com>
References: <4FD5E466.4050409@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FD5E466.4050409@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

i noticed this while twiddling with RAID1 arrays...

On our old CentOS 4.7 box, i can mount a RAID1 array member independently of the array -- i.e. mount /dev/sdc1 /mountpoint....but on CentOS 5.x and later i am met with an unknown filesystem: linux_raid_member error. 

Somebody hinted that this had something to do with the metadata versions, so i recreated the RAID1 array on CentOS 5.x with the --metadata=0.90 parameter...and was able to mount the array member w/o any problems.


Is this expected behavior? Are there any potential problems if i stick with metadata=0.90(apart from the 28 device and 2Tb disk space limit)?


tia

 
