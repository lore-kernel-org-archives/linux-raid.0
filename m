From: Andrew Martin <amartin@xes-inc.com>
Subject: Automatically drop caches after mdadm fails a drive out of an
 array?
Date: Tue, 11 Feb 2014 11:11:04 -0600 (CST)
Message-ID: <1090802800.32078.1392138664718.JavaMail.zimbra@xes-inc.com>
References: <1413719638.30344.1392138285471.JavaMail.zimbra@xes-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1413719638.30344.1392138285471.JavaMail.zimbra@xes-inc.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I am running mdadm 3.2.5 on an Ubuntu 12.04 fileserver with a 10-drive RAID6 array (10x1TB). Recently, /dev/sdb started failing:
Feb 10 13:49:29 myfileserver kernel: [17162220.838256] sas: command 0xffff88010628f600, task 0xffff8800466241c0, timed out: BLK_EH_NOT_HANDLED

Around this same time, a few users attempted to access a directory on this RAID array over CIFS, which they had previously accessed earlier in the day. When they attempted to access it this time, the directory was empty. The emptiness of the folder was confirmed via a local shell on the fileserver, which reported the same information. At around 13:50, mdadm dropped /dev/sdb from the RAID array:
Feb 10 13:50:31 myfileserver mdadm[1897]: Fail event detected on md device /dev/md2, component device /dev/sdb

However, it was not until around 14:15 that these files reappeared in the directory. I am guessing that it took this long for the invalid, cached read to be flushed from the kernel buffer cache.

The concern with the above behavior is it leaves a potentially large window of time during which certain data may not be correctly returned from the RAID array. Is it possible for mdadm to automatically flush the kernel buffer cache after it drops a drive from the array:
sync; echo 3 > /proc/sys/vm/drop_caches

This would have caused the data to have been re-read at 13:50, a much smaller window of time during which invalid data was present in the cache. Or, is there a better suggestion for handling this situation?

Thanks,

Andrew Martin
