From: Khelben Blackstaff <eye.of.the.8eholder@gmail.com>
Subject: Re: Alignment of RAID on specific boundary
Date: Wed, 6 Jan 2010 16:44:31 +0200
Message-ID: <7b3edae11001060644j4d3d6742n2da0776480237766@mail.gmail.com>
References: <7b3edae11001041130n42d053fcpc4923b22278c5671@mail.gmail.com>
	 <4877c76c1001042257h49103054t977de11410eb65c6@mail.gmail.com>
	 <7b3edae11001050544p4f99d7dbq83b72e385151c27@mail.gmail.com>
	 <4B435C2E.4000201@anonymous.org.uk>
	 <4877c76c1001051746q25df0a3dq5d9973dbdc27c583@mail.gmail.com>
	 <7b3edae11001060500g2d63f2cav81bf8a90fc0b946b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7b3edae11001060500g2d63f2cav81bf8a90fc0b946b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2010/1/6 Michael Evans <mjevans1983@gmail.com>:
> <john.robinson@anonymous.org.uk> wrote:
>> Or move your partition start back by 136 sectors, or use version 0.90 or 1.0
>> superblocks which have the superblock at the end.
> Indeed, that was one route I covered earlier in my message.
>
> However it is still a good idea improvement for mdadm to allow the
> user to specify a non-default offset for the start of the
> data-partition (for a number of reasons).
>

Yes, it will be nice if Mr. Brown implements this when he finds
the time. I will use v1.0 as you both suggested till then.

Since i am experimenting in Virtualbox, i tried to
hexedit the superblock. I modified 0x80 (offset)
from 136 to 256 and subtracted 256-136=120
from 0x88 (size). It seems to work fine :)

Of course i did this because it is a test array in VB.
I wouldn't mess with the real array. I just wanted
to see if it will work.

Thank you all for your help.
