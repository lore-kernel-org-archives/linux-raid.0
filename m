From: Hein Roehrig <hpr@eml.cc>
Subject: Re: 2.2.17 -> 2.4.19-rc3: bub in file md.c, line 1311
Date: 24 Jul 2002 14:51:02 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1027515064.2448.27.camel@qaip3>
References: <87r8huqy5t.fsf@qaip3.ins.cwi.nl>
	<15678.23310.273599.821682@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15678.23310.273599.821682@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2002-07-24 at 09:45, Neil Brown wrote:
> The 2.2 patches got the superblock layout wrong for sparc64, so raid
> array made on those systems are not directly compatable with 2.4.

Ah, thanks for the information, I hadn't found that on Google or the
mailing list archive.

I gather that fixing the superblock for 2.4 will make it unusuable for
2.2? So I'll have to be very careful... 

Thanks,
Hein


