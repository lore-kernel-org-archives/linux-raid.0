From: Xavier Nicollet <nicollet@jeru.org>
Subject: --detail --test exit status
Date: Wed, 29 Jun 2016 23:19:22 +0200
Message-ID: <20160629211922.GE18087@jeru.org>
Reply-To: nicollet@jeru.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I've hit the same problem as this one:
https://www.mail-archive.com/linux-raid@vger.kernel.org/msg06567.html

Basically with raid1 "mdadm --detail --test /dev/md0" returns 0 even if
only one drive is still alive.

I think it's coming from the enough() function from util.c:

int enough(int level, int raid_disks, int layout, int clean, char
*avail)

/.../
 case 1:
                 return avail_disks >= 1;
/.../

It's called from Detail.c:
       if (c->test && !enough(array.level, array.raid_disks, array.layout,
		1, avail))
			rv = 2;

I think each time we print DEGRADED or FAILED, we should modify rv
accordingly.

I am missing something?

-- 
Xavier Nicollet
