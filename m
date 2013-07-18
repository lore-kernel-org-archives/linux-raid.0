From: Francis Moreau <francis.moro@gmail.com>
Subject: How does md(adm) work with fake-raid ?
Date: Thu, 18 Jul 2013 22:37:32 +0200
Message-ID: <CAC9WiBjU_A0jsB4KoX4B9ohT4TD3cYuDdioM6hSWfK13Otjs-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

Sorry if the question is stupid but I'm a rookie in md things, but I'd
like to understand the big picture here.

I've been told to use mdadm whenever possible even if my raid is
handled by the bios (fake raid) which use the ddf metadata format.
(unfortunately it seems that I can't desactive this fake raid in
favour of linux soft raid). It's RAID1 BTW.

So my question is rather simple: in my understanding the bios is doing
the mirroring, but when setting up the md device, linux (kernel or
userspace, I don't really know) also handles the mirroring for RAID1
personnality. Is Linux clever enough to see that the mirroring is done
by the bios in my case ?

Could anybody teach me the big picture ?

Thanks a lot.
--
Francis
