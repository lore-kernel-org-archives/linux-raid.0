From: Dragon <Sunghost@gmx.de>
Subject: raid6 didnt syncing - Bug?
Date: Mon, 9 Nov 2015 23:36:31 +0100
Message-ID: <trinity-a74c22f8-82cd-405f-8b77-1525a79c8ae8-1447108590600@3capp-gmx-bs60>
References: <trinity-0d27a99a-dc46-4d38-9b35-65b422d41f15-1447106962768@3capp-gmx-bs60>,
 <trinity-850e4e87-8977-46fa-9382-c97a137130a8-1447108068694@3capp-gmx-bs60>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
i have debian with kernel 4.2 and wanted to add a new disk to my raid6. i have md0=system in raid1, md1=swap n raid6 and md2=files also in raid6. here are the mdadm -E output: http://pastebin.com/MveRQ2Lv.
i stop md1 and run assamble, but without success. i stop md1 and wait for md2 but no success. at boot i see message "md/raid:md2: reshape: not enough stripes. Needed 512" and run echo and rise from 256 to 600 for stripes, but without success. any idea?
thx
