From: "Eric Wood" <eric@interplas.com>
Subject: Put harddrives in standby mode to prevent raid rebuilds
Date: Fri, 16 Apr 2004 10:42:42 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <009a01c423c1$12ca88e0$b100000a@M145Primary>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

After getting a raid-1 setup going (hda, hdc), I was dismayed that the raid
kept rebuilding each member after a reboot or shutdown.  It's as though the
Shuttle system would power off prematurely before md had a chance to flush
it's data.

So, looking at the Fedora shutdown script /etc/rc.d/init.d/halt, I noticed I
could put halt parameters in there.  Looking at the man page for halt:

# man halt
....
      -h     Put all harddrives on the system in  standby  mode  just
before halt or poweroff.
....

So, I added a -h to the halt arguments and the system now flushes the md
data just before poweroff or reboot.  No more raid rebuilds so I'm happy.

The side effect is that the drives quickly spin down, spin up, flush data,
go into standby, then power off.  Reminds of Han Solo's Millenium Falcon
trying to fire up.  Anyway, this workaround may help some people.

-Eric Wood

