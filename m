From: Chris Murphy <lists@colorremedies.com>
Subject: Re: GPT corruption on Primary Header, backup OK, fixing primary nuked
 array -- help?
Date: Tue, 26 Jul 2016 09:19:51 -0600
Message-ID: <CAJCQCtQ73Tp_ps57qgDm=S_qdFMHy8J0Z=kB+_TfQD2ugj_6ow@mail.gmail.com>
References: <5796B46B.6060905@suddenlinkmail.com> <413b1150-ca38-1907-ea5d-b68ad2f75710@websitemanagers.com.au>
 <5796F4E0.9070206@suddenlinkmail.com> <57971D3C.8040602@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57971D3C.8040602@suddenlinkmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Cc: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

It'd be interesting to see mdadm -E for sdc and sdd.

GPT uses LBA 0-3. And mdadm metadata 1.2 is 4K from the start. These
do not overlap. So I'm unconvinced that mdadm -C applied to sdc and
sdd instead of sdc1 and sdd1 is the source of the problem.

Further, gdisk specifically said the GPT header was corrupt. The PMBR,
LBA 0, is intact, and the table data (LBA 2) is intact. Only LBA 2 was
stepped on by something?

What do you get for gdisk -l /dev/sdc? Another warning or is it OK?

Also for what it's worth: primary, extended, logical are terms that do
not apply to GPT partitioned disks. There is only one kind of
partition with GPT disks, no distinctions.


-- 
Chris Murphy
