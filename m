From: Andrew Pam <xanni@glasswings.com.au>
Subject: md.c patch for root on RAID-10
Date: Wed, 21 Apr 2004 18:19:36 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040421081936.GS1352@glasswings.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: Ingo Molnar <mingo@redhat.com>, Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a server that is configured with the root partition on a RAID-10
array (/dev/md5 is RAID-1 /dev/md[34], /dev/md3 is RAID-0 /dev/sd[ab]2,
/dev/md4 is RAID-0 /dev/sd[cd]2).

This server boots Linux kernel 2.6.3 off /dev/md0 RAID-1 /dev/sd[abcd]1
(about to upgrade to 2.6.5) but unfortunately requires a complicated
custom initrd to boot correctly since the RAID autorun code does not
appear to autostart multilayer RAID arrays.  Can you offer me any
assistance in patching md.c to make it check if any autostarted RAID
arrays are themselves components of other RAID arrays that should also
be autostarted?

Thanks,
	Andrew Pam
-- 
mailto:xanni@xanadu.net                         Andrew Pam
http://www.xanadu.com.au/                       Chief Scientist, Xanadu
http://www.glasswings.com.au/                   Technology Manager, Glass Wings
http://www.sericyb.com.au/                      Manager, Serious Cybernetics
