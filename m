From: TJ <systemloc@earthlink.net>
Subject: Order of kernel autodetect
Date: Sun, 17 Apr 2005 02:21:35 -0400
Message-ID: <200504170221.35082.systemloc@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I searched through the mailing list archive but I can not find this. I 
remember a discussion about trouble being caused from lack of control of the 
order that kernel autodetect chooses, and a patch to be able to control it. 
I'm running an array on top of another array right now, a RAID 5 on a linear. 
I understand the consequences of this, it's temporary. Still, the kernel 
tries to bring up the RAID 5 array before the linear, so the linear array is 
not included. If there is no way to correct this in the kernel, I need some 
help on understanding how init.rd level raid starting is supposed to work. It 
must happen very early, obviously, to ensure that auto-fsck works correctly. 
I'm guessing that it should be first, or close to first in the scripts. The 
general idea would be simply to run mdadm from a script to start the arrays, 
then? 

Thanks
TJ
