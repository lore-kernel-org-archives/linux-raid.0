From: Benjammin2068 <benjammin2068@gmail.com>
Subject: Sanity Check: RAID1 with 4 members + Spare
Date: Wed, 16 Aug 2017 23:52:06 -0500
Message-ID: <108d7193-d41a-9390-5fc3-10eac37cd39c@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hey all,


  I'm looking to make a 16TB raid1 from (4) 8TB members + 8TB Spare.

when I put in:

 mdadm --create /dev/md/RecordingRAID --level=mirror --name=RecordingRAID --raid-devices=4 /dev/sda1 /dev/sdd1 /dev/sde1 /dev/sdl1 --spare-devices=1 /dev/sdn1


 I end up with an 8TB RAID.... not what I'm looking for...

Should I be doing something different?

Thanks,


 -Ben


p.s. (https://raid.wiki.kernel.org/index.php/RAID_setup doesn't show a good example of this. only 2+1)

