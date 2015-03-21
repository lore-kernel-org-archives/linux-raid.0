From: lingli tang <tanglingli001@gmail.com>
Subject: is mdadm RAID1 disk full sync
Date: Sat, 21 Mar 2015 19:01:54 +0800
Message-ID: <CAN+bsqhy0Bao1hAn3R-KtXWOjYb8O2LDo+E1jNdktWdduUL4vw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am a newbie of mdadm. I have a question but find no answer in
document or google for last 10 days.

The question is : RAID1 made by mdadm is full sync? for example, I
have two disk(sdb and sdc) to make RAID1 disk (/dev/md127), if I
commit an IO to the RAID1 disk (md127), it will return back to me when
all the two disk commit successfully      or      it will return back
to me once just one of the disk successfully commit.

I have test with xfs and ext4 with sync option, and it seems that two
disk have lots of commit difference after reboot the server. is that
means mdadm return success when one of the disk is commit
successfully?
