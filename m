From: Joaquin Ferrero <explorer@aprosi.net>
Subject: Problem with Openmosix
Date: Mon, 14 Feb 2005 22:52:52 +0100
Message-ID: <1108417972.2873.9.camel@next3.aprosi.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, Neil...

I use MD driver two year ago with Debian, and run perfectly.

Now, I added our machine to a cluster with kernel 2.4.27 and openmosix
patches. We wish to use the cluster to power our primary machine.

I copied the kernel, modules and initrd from the running cluster to the
machine (openmosix need all nodes with same kernel version).

The machine boot the new kernel a run Ok... but... if I (or another
process) make a change/write to the raid md system, the computer crash
with the message:

	hdh: Drive not ready for command.

(hdh is the mirror raid1 for hdf disk).

Is MD driver not openmosix-ware?

Thanks!

-- 
Joaquin Ferrero <explorer@aprosi.net>
APROSI

