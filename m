From: Mario 'BitKoenig' Holbe <Mario.Holbe@RZ.TU-Ilmenau.DE>
Subject: Re: strange lilo error
Date: Tue, 15 Jun 2004 10:25:42 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <cambq6$pae$1@sea.gmane.org>
References: <20040615073953.GA25753@apartia.fr>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Louis-David Mitterrand <vindex@apartia.org> wrote:
> Once /dev/hdb1 and /dev/hdb2 have been marked faulty and removed lilo
> will fail with the following message:
> Fatal: Trying to map files from unnamed device 0x0000 (NFS/RAID mirror down ?)

Well, this is coherent, isn't it?

> After running a few tests it appears lilo will only stop complaining
> once the original raid1 set is restored _and_ synchronized.
[...]
> Any idea? Thanks in advance,

Well, a question at first :)
Why do you need to run lilo after you failed one of the mirrors?

Anyways - I'm running lilo on degraded arrays and it works
very well.
Thus, I presume, it works for you too, once you remove the
failed mirror from the array.


regards,
   Mario
-- 
Whenever you design a better fool-proof software,
the genetic pool will always design a better fool.

