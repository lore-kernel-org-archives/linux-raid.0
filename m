From: Ewan Grantham <ewan.grantham@gmail.com>
Subject: Getting md0 to come back automatically
Date: Sat, 6 Aug 2005 19:11:49 -0500
Message-ID: <6d5bedd8050806171140e7f9dd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'm running mdadm 1.9.0 on a Debian build (using coLinux 0.7.1), and
have the following for my /etc/mdadm/mdadm.conf:

ARRAY /dev/md0 level=raid5 num-devices=4
UUID=777b15e6:6791bb61:96a9c2f4:80e2f7bf
DEVICE /dev/cobd3,/dev/cobd4,/dev/cobd5,/dev/cobd6

I can rebuild the array manually after a restart using:

mdadm -A /dev/md0 /dev//cobd3 /dev/cobd4 /dev/cobd5 /dev/cobd6

but it doesn't come up automatically on it's own. Anything that y'all
can see that's wrong with this?

Thanks,
Ewan
