From: "Tirumala Reddy Marri" <tmarri@amcc.com>
Subject: writes raid-6  building
Date: Mon, 27 Jul 2009 18:09:11 -0700
Message-ID: <AC5E1C3367E37D44970B81A6ADD1DA2C07C7D260@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

While raid-6 is building I noticed writes are going on to all the
drivers. Whereas in  raid-5 I see writes happening to only one drive.
Any clue ?

---------- iostat dump for raid-6 ---
Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
sda             152.76        23.81         3.74         47          7
sdb             181.91        25.35         5.50         50         10
sdc             161.31        24.84         3.30         49          6
sdd             153.77        23.52         4.02         46          8
sde             169.85        26.29         3.27         52          6
sdf               0.00         0.00         0.00          0          0
sdg               0.00         0.00         0.00          0          0
sdh               0.00         0.00         0.00          0          0
sdi               0.00         0.00         0.00          0          0

Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
sda             152.02        24.05         3.44         47          6
sdb             168.18        26.23         4.14         51          8
sdc             163.64        22.76         3.69         45          7
sdd             166.67        24.37         4.04         48          8
sde             166.16        24.78         3.57         49          7
sdf               0.00         0.00         0.00          0          0
sdg               0.00         0.00         0.00          0          0
sdh               0.00         0.00         0.00          0          0
sdi               0.00         0.00         0.00          0          0
---------------
Thanks,
Marri
