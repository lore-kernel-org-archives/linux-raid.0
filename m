From: sylvain.depuille@laposte.net
Subject: Big trouble during reassemble a Raid5
Date: Sun, 28 Dec 2014 13:16:21 +0100 (CET)
Message-ID: <938521225.11264152.1419768981146.JavaMail.zimbra@laposte.net>
References: <2105542796.11263344.1419768937013.JavaMail.zimbra@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2105542796.11263344.1419768937013.JavaMail.zimbra@laposte.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello, 

i'm sorry to ask this questions but the raid 5 with 4 disk is in big trouble during re-assemble. 2 disks are out of order. 
I have change a disk of the raid 5 (sde) to growing the raid. 
But a second disk (sdc) have too many bad sector during the re-assemble, and shutdown the re-assemble. 
"mdadm --assemble --force /dev/md2 /dev/sd[bcde]1" 
I have try to correct bad sectors with badblocks, but it's finished by no more spare sectors and the disk still have some bad sector. 
badblocks -b 512 -o badblocks-sdc.txt -v -n /dev/sdc 1140170000 1140169336 
1140169400 
1140169401 
1140169402 
1140169403 
1140169404 
1140169405 
1140169406 
1140169407 
1140169416 
1140169417 
1140169418 
1140169419 
1140169420 
1140169421 
1140169422 
1140169423 


For information the mdadm examine return : 
cat mdadm-exam.txt 
/dev/sdb: 
MBR Magic : aa55 
Partition[0] : 1953523120 sectors at 2048 (type fd) 
/dev/sdc: 
MBR Magic : aa55 
Partition[0] : 1953520002 sectors at 63 (type fd) 
/dev/sdd: 
MBR Magic : aa55 
Partition[0] : 1953520002 sectors at 63 (type fd) 
/dev/sde: 
MBR Magic : aa55 
Partition[0] : 4294965247 sectors at 2048 (type fd) 

I have 2 way to solve the issue. 
The first, is to have special command to pass bad sector during re-assemble as "mdadm --assemble --force /dev/md2 /dev/sd[bcde]1" 
The second is change the disk sde with the old good one, but some datas have been changed on the raid since i have remove it. But these datas are not important. It's only logs and history activity. 

What can i do to recover a maximum datas without too many risk? 

Thank's in advance 
Best Regards 
---------------------------------- 
Sylvain Depuille (in trouble) 

sylvain.depuille@laposte.net 
