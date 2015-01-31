From: LuVar <luvar@plaintext.sk>
Subject: unsynchronized raid10 with different events count
Date: Sat, 31 Jan 2015 14:52:17 +0100 (GMT+01:00)
Message-ID: <1468090491.36611422712337250.JavaMail.root@shiva>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,
I have raid with 9 devices, layout n3. It is not possible to autoassemble it with all devices, because 4 devices has different number of events... How can I assemble it fully and sync with 5 devices which have slightly more events? My current state after mdadm --assemble /dev/...... is this: http://pastebin.com/vEpd8WWW

I know that I can delete those 4 disks and add them again, but I do not want to experiment if removed and newly added disk will be on correct place in raid and also I would like to not synchronize whole disks. They miss only a few events. Is there any possibility?

PS: here is complete examine output: http://cwillu.com:8080/188.121.181.8/8 and cat /proc/mdstat is here: http://cwillu.com:8080/188.121.181.8/9
