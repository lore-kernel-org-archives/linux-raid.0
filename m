From: Gewj <geweijin@sinosoft.com.cn>
Subject: A puzzling thing about RAID5: syslogd write the log success but another
 process can not read the /var/log/messages
Date: Wed, 07 Apr 2004 21:24:01 +0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <407400F1.8090809@sinosoft.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

hammm,tonight is funny because I got a puzzling thing just as....

my setup is a two-scsi-disk raid5 configuration...
(Linux version 2.4.18-18.7.xsmp (Red Hat Linux 7.3 2.96-112)) #1 SMP Wed
Nov 13 19:01:42 EST 2002)
it work well for a long time, but now I found some day early one of the
scsi disks failed, and I found out
that that time syslogd restarted(why??) and it could write log infor to
log file successfully.
but at the same time , another process(named such as B,run by root) can
not read
the /var/log/messages,or what's more exactly, the messages file was look
like empty to B then.
(of course, the syslogd write log infor to /var/log/messages )

I wonder that if syslogd write the log infor to the well-work scsi disk
, but the process B
read the /var/log/messages from the crashed scsi disk,which cause it
just like a empty file.

yes, it is quite unbelievable. but can some one show me a clue to this
puzzling problem?
What is the proper course of this action?










