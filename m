From: Daniel Reurich <daniel@centurion.net.nz>
Subject: Bug#567468: md homehost (was: Bug#567468: (boot time consequences of) Linux mdadm superblock) question.
Date: Tue, 23 Feb 2010 00:11:51 +1300
Message-ID: <1266837111.24834.365.camel@localhost.localdomain>
References: <20100218032610.GB1991@lapse.rw.madduck.net>
	 <1266465801.11568.183.camel@localhost.localdomain>
	 <20100218044004.GC5136@lapse.rw.madduck.net>
	 <20100218161012.704b43a6@notabene.brown>
	 <20100218052145.GA7178@lapse.rw.madduck.net>
	 <20100218163448.0d3f3107@notabene.brown>
	 <20100219004237.GC25162@lapse.rw.madduck.net>
	 <20100219091619.GA2964@lazy.lzy>
	 <20100221174007.GB19058@lapse.rw.madduck.net>
	 <20100221201304.GB2570@lazy.lzy>
	 <20100222091632.GE2641@lapse.rw.madduck.net>
Reply-To: Daniel Reurich <daniel@centurion.net.nz>, 567468@bugs.debian.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.567468.B567468.126683711622666@bugs.debian.org>
In-Reply-To: <20100222091632.GE2641@lapse.rw.madduck.net>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
To: martin f krafft <madduck@madduck.net>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, 567468@bugs.debian.org, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Could you please put forth the argument for why the homehost must
> match, and why unconditional auto-assembly is not desirable?
> Realistically, what problems are we protecting against?

I can think of one or two.  

In the case of network boot, where the kernel and initrd served up via
tftp, but the required filesystems are per host raid volumes served up
ala ATAoverEthernet, iSCSI etc storage network.  This could use the boot
network device MAC or dhcp assigned hostname to as the homehost search
paramater.  This would of course require someway to tell mdadm how to
obtain this homehost parameter.  This could work well where different
groups of hosts using different raid volumes for the root (or other)
filesystems, each with a MAC group (first 3 or 4 MAC fields) is used to
identify that groups homehost search parameter.  

Another scenario, is a dual boot system that has separate raid volumes
for the respective root filesystems, along with a separate initrd image
for each OS.  A system uuid stored in the initrd would work in this case
for the homehost search parameter.


-- 
Daniel Reurich.

Centurion Computer Technology (2005) Ltd
Mobile 021 797 722
