From: "Jeff Breidenbach" <jeff@jab.org>
Subject: Re: mdadm break / restore soft mirror
Date: Thu, 13 Dec 2007 23:40:02 -0800
Message-ID: <e03b90ae0712132340t61e3bef6x8159e6d24da9c254@mail.gmail.com>
References: <05ED21952E28E94E8352836547A6BA37042318B3@achmsx001.hsa.co.uk>
	 <18272.34965.638276.892803@notabene.brown>
	 <e03b90ae0712122000m439069y8ccad65c59cf4de9@mail.gmail.com>
	 <18272.45576.359862.395170@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18272.45576.359862.395170@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Brett Maton <Brett.Maton@simplyhealth.co.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> What you could do is set the number of devices in the array to 3 so
> they it always appears to be degraded, then rotate your backup drives
> through the array.  The number of dirty bits in the bitmap will
> steadily grow and so resyncs will take longer.  Once it crosses some
> threshold you set the array back to having 2 devices to that it looks
> non-degraded and clean the bitmap.  Then each device will need a full
> resync after which you will get away with partial resyncs for a while.

I don't undertand why clearing the bitmap causes a rebuild of
all devices. I think I have a conceptual misunderstanding.  Consider
a RAID-1 and three physical disks involved, A,B,C

1) A and B are in the RAID, everything is synced
2) Create a bitmap on the array
3) Fail + remove B
4) Hot add C, wait for C to sync
5) Fail + remove C
6) Hot add B, wait for B to resync
7) Goto step 3

I understand that after a while we might want to clean the bitmap
and that would trigger a full resync for drives B and C. I don't
understand why it would ever cause a resync for drive A.
