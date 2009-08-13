From: "John Robinson" <john.robinson@anonymous.org.uk>
Subject: Array management
Date: Thu, 13 Aug 2009 17:35:55 +0100 (BST)
Message-ID: <64980.78.86.108.203.1250181355.squirrel@www.yuiop.co.uk>
Mime-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

What tools do you guys use to automate your array management? I mean, I'd
quite like to be able to pre-configure that certain drive slots should
have drives re-added or re-built automatically when I hot plug drives,
then have it Just Happen.

Even better if I could do something like Infrant/Netgear's ReadyNAS
X-RAID, which just does the Right Thing as you add drives. 1 drive, no
redundancy. Add a second, RAID-1. Add a third, convert to RAID-5. Add a
fourth, grow the RAID-5. (Actually it's easier than that, just start with
a 2-drive RAID-5 with one drive missing.) Now, Infrant/Netgear will have
rolled their own, but is there a package which would help me automate this
sort of thing?

Cheers,

John.

-- 
John Robinson, yuiop IT services
0131 557 9577 / 07771 784 058
46/12 Broughton Road, Edinburgh EH7 4EE

