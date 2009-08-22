From: Igor Podlesny <for.poige+linux@gmail.com>
Subject: man mdadm regarding --assume-clean says it's OK to use with RAID1 or
	10, when creating:
Date: Sat, 22 Aug 2009 22:01:03 +0800
Message-ID: <43d009740908220701j25b26bd8o4ac0030121544c32@mail.gmail.com>
Reply-To: for.poige+linux@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

	"... It can also be used when creating a RAID1 or RAID10 if you want
to avoid  the  initial  resync ..."
	
	I'm wondering why namely those levels are chosen and not RAID5/6 for e. g.?
	
	I think it's also safe to use with RAID5/6, isn't it?

-- 
End of message. Next message?
