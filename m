From: "JaniD++" <djani22@dynamicweb.hu>
Subject: Re: [PATCH md ] Better handling of readerrors with raid5.
Date: Mon, 19 Sep 2005 00:06:08 +0200
Message-ID: <028d01c5bc9d$2f4f2310$0400a8c0@dcccs>
References: <20050916125754.11044.patches@notabene> <1050916030157.11071@suse.de> <432AF89C.3040407@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello list!

I have found today one bad drive! (Maxtor 200G IDE)
I have also lost a lot of data thanks to that drive.

The problem:
The drive goes to crazy, and "can't remember", but dont say any error!
The RAID5 is still used that drive, and wasted the data what the system
writes to it...

I dont know is there any good trick to detect this error, but I have one
idea that can help some people on similar situation....

The job is simple:
Recover from RAID5 parity information, but don't write the data to any disk,
just verify the original data from drives, and reply the differences!
(same on raid1)

This helps to detect this light-bug drives.

And it is more useful, if the kernel can do that on the working array with
low priority...

I am lucky, because I have found easy this bad drive, that loses own MBR,
and 2 raid superblocks! :-) (raid0 on raid5)

Thanks

Janos

