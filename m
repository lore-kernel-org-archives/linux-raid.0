From: Alberto Alonso <alberto@ggsys.net>
Subject: I/O errors, server unresponsive, array NOT-degraded
Date: Tue, 22 May 2007 21:59:28 -0500
Message-ID: <1179889168.21028.53.camel@w100>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've been having a recurring problem for about two months 
now.

I have a brand new server where suddenly everything except
the web service stops responding.

When looking at the console I can see messages like:

end_request: I/O error, dev sdb, sector 42644555
end_request: I/O error, dev sdb, sector 42644555
end_request: I/O error, dev sdb, sector 42644555
end_request: I/O error, dev sdb, sector 124365763
end_request: I/O error, dev sdb, sector 124365763
[...]

My array setup can be summarized as follows:

# cat /proc/mdstat
Personalities : [raid1]
md2 : active raid1 sda3[0] sdb3[1]
      75473280 blocks [2/2] [UU]
      [===>.................]  resync = 19.0% (14366720/75473280)
finish=51.4min speed=19791K/sec

md3 : active raid1 sda4[0] sdb4[1]
      803136 blocks [2/2] [UU]

md1 : active raid1 sda2[0] sdb2[1]
      3911744 blocks [2/2] [UU]

md0 : active raid1 sda1[0] sdb1[1]
      224768 blocks [2/2] [UU]


After a while the array rebuilds without problems. Then the
system runs anywhere from 5 to 15 days and crashes again.

This is using kernel: 2.6.18-4-686 #1 SMP (Debian kernel)

I have two questions that I hope someone can answer:

* Am I safe to assume that since the array rebuilds that the
disks themselves should be OK?

* Why is the md device not being downgraded?

Thanks,

Alberto

-- 
Alberto Alonso                        Global Gate Systems LLC.
(512) 351-7233                        http://www.ggsys.net
Hardware, consulting, sysadmin, monitoring and remote backups

