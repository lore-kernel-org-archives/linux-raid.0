From: Alberto Alonso <alberto@ggsys.net>
Subject: When does a disk get flagged as bad?
Date: Thu, 24 May 2007 23:16:35 -0500
Message-ID: <1180066595.21028.112.camel@w100>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

OK, lets see if I can understand how a disk gets flagged
as bad and removed from an array. I was under the impression
that any read or write operation failure flags the drive as
bad and it gets removed automatically from the array.

However, as I indicated in a prior post I am having problems
where the array is never degraded. Does an error of type:
end_request: I/O error, dev sdb, sector ....
not count as a read/write error?

Thanks,

Alberto

-- 
Alberto Alonso                        Global Gate Systems LLC.
(512) 351-7233                        http://www.ggsys.net
Hardware, consulting, sysadmin, monitoring and remote backups

