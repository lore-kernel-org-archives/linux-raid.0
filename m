From: "Alexandru N. Barloiu" <slak@dale.ro>
Subject: very stupid question about dpt_i2o
Date: 11 Aug 2003 13:22:13 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1060597333.5057.8.camel@hammer.dale.ro>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am using Adaptec 2400A raid board with 4 drives in raid0 with 64k
chunks. the drives are all identical. i was wondering if it is posible
to use software raid and drop the hardware raid. i can use i2o_scsi
instead of dpt_i2o to gain direct access to drives and try to reuse the
old array. Is that posible without loosing the old data (of course
keeping the old paramenters of the array, and order of drives) ?


-- 
Alexandru N. Barloiu <slak@dale.ro>
Dale Media

