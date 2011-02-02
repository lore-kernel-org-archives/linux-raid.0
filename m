From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Kernel 2.6.32-5-amd64 fails to boot.
Date: Wed, 2 Feb 2011 11:00:03 -0600
Message-ID: <65.C8.19545.59D894D4@cdptpa-omtalb.mail.rr.com>
References: <alpine.DEB.2.00.1102020557270.21703@p34.internal.lan>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1102020557270.21703@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: 'Justin Piszcz' <jpiszcz@lucidpixels.com>
Cc: 'Rudy Zijlstra' <rudy@grumpydevil.homelinux.org>, 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Check the network console documentation in the kernel.  Essentially, in
> LILO, run:

	I'm not using LILO.

> append="netconsole=4444@192.0.0.1/eth0,514@192.0.0.2/00:60:2D:CD:2A:B7"
>                               ^^ src                  ^^dest / ^dest mac
> addr
> 
> On the remote host, run syslogd -r (to accespt remote syslogging)
> 
> This *is* clearly documented here in the kernel docs:
> linux/Documentation/networking/netconsole.txt

	It is?  It doesn't look that clear to me:

Backup:/etc/mdadm# cd linux/Documentation/networking/
-bash: cd: linux/Documentation/networking/: No such file or directory

> It takes a string configuration parameter "netconsole" in the
> following format:
> 
>   netconsole=[src-port]@[src-ip]/[<dev>],[tgt-port]@<tgt-ip>/[tgt-macaddr]
> 
>     where
>          src-port      source for UDP packets (defaults to 6665)
>          src-ip        source IP to use (interface address)
>          dev           network interface (eth0)
>          tgt-port      port for logging agent (6666)
>          tgt-ip        IP address for logging agent
>          tgt-macaddr   ethernet MAC address for logging agent (broadcast)

	Thanks.  I'll give it a shot.
 


