From: hansbkk@gmail.com
Subject: Re: Inconsistent UUIDs between mkconf vs blkid
Date: Fri, 4 Feb 2011 14:20:16 +0700
Message-ID: <AANLkTinUsT6XU_9=xLeRK7hMfyM_pQ6a=a74-wjqgeTL@mail.gmail.com>
References: <AANLkTimpqwEoyZTNB+as0UyK8uOAy7P1fihBUBpd1tCs@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimpqwEoyZTNB+as0UyK8uOAy7P1fihBUBpd1tCs@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Sorry, but I just noticed a new wrinkle that may be helpful
(particularly for others googling this later)

mdadm -D reports a UUID that agrees with blkid as opposed to mkconf

However I noticed that  the "section delimiters" within the UUID are
colons rather than dashes, and in a few places these colons are in
different places compared to blkid's dashes.

I've tested  mdadm --update=uuid and this has (quite logically)
allowed me to just use a number string without any dashes or colons.

I've got a big RAID6 currently rebuilding under sysresccd, so I can't
test with the debian/ubuntu tools ATM, but I'll try to remember to do
so in the 10-12 hours that'll take to finish.
