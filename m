From: Albert Pauw <albert.pauw@gmail.com>
Subject: auto-read-only question
Date: Fri, 25 Feb 2011 17:07:48 +0100
Message-ID: <4D67D3D4.9040306@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

  Can anybody explain to me what "active (auto-read-only)" mean in 
/proc/mdstats? So the full entry in /proc/mdstats is:

Personalities : [raid1]
md2 : active (auto-read-only) raid1 sdd[1] sde[0]
           1015808 blocks super external:/md127/0 [2/2] [UU]

md1 : active (auto-read-only) raid1 sdb[1] sdc[0]
           1015808 blocks super external:/md127/0 [2/2] [UU]

md127 : inactive sdb[4](S) sdf[3](S) sde[2](S) sdd[1](S) sdc[0](S)
            163840 blocks super external:ddf

unused devices: <none>


(Yes, two raid1 sets in a ddf container).

Thanks,

Albert
