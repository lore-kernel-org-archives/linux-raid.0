From: Ferenc Wagner <wferi@niif.hu>
Subject: how to disable partition search?
Date: Wed, 26 Mar 2008 12:43:41 +0100
Message-ID: <87ve39lngy.fsf@tac.ki.iif.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I use an FC SAN, which provides multiple pathes to multiple LUNs.
These all come up as different sd* devices, exhausting single letter
names.  I mean they are a LOT.  Using the md mulitpath driver
everything works perfectly, no problems there.  However, during boot,
the kernel tries to read the partition table from each device,
spitting out hundreds of lines of error messages: most of the devices
aren't even readable, and those which are, don't contain a valid
partition table.  They never will.  So I'd like to disable partition
detection, because these messages overflow the kernel message buffer,
depriving syslog of gathering any useful boot messages, and also
needlessly lengthening the boot process.  (Of course the noise alone
is disturbing enough when one tries to troubleshoot a boot problem.)
However, looking at the kernel sources didn't give me any hint.  Is
this possible to disable at all?

(Please Cc me, I'm not on the list.)
-- 
Thanks,
Feri.
