From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: 2.2.17 -> 2.4.19-rc3: bub in file md.c, line 1311
Date: Wed, 24 Jul 2002 17:45:18 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15678.23310.273599.821682@notabene.cse.unsw.edu.au>
References: <87r8huqy5t.fsf@qaip3.ins.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Hein Roehrig on  July 23
To: Hein Roehrig <hpr@eml.cc>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On  July 23, hpr@eml.cc wrote:
> I am trying to (remotely) upgrade a kernel 2.2.17 with raid-2.2.17-A0
> patch to 2.4.19-rc3 with the little attached patch to get autodetect
> to work (sparc64 architecture.) Here is a partial manual transcript
> from what appears on the console; the system still boots 2.2.17
> without problem. I would be grateful for any advice on getting things
> right...

The 2.2 patches got the superblock layout wrong for sparc64, so raid
array made on those systems are not directly compatable with 2.4.

You can convert the arrays using mdadm 1.0.1 which can be found at
  http://www.cse.unsw.edu.au/~neilb/source/mdadm/

For each component device:
 mdadm -E /dev/devicename
should show rubbish in the device table at the bottom as the
superblock layout is wrong
 mdadm -E --sparc2.2 /dev/devicename
should show correct information in the device table.
If it does then:
 mdadm -E --sparc2.2update /dev/devicename
should correct the superblock for 2.4. After this
 mdadm -E /dev/devicename
will show correct devices and
 mdadm -A /dev/mdX /dev/sd.....

should assemble the devices successfully.

NeilBrown
