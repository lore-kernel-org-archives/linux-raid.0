From: Martin Hermanowski <martin@martin.mh57.net>
Subject: raid1 over lvm and nbd => recovery thread fails
Date: Fri, 5 Jul 2002 12:52:15 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020705105215.GK26595@martin.mh57.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,
I've made a raid1 mirror of an lvm partition and an nbd from another
machine. Then I created an ext3 fs on it. I patched nbd-client.c to
close the socket on network failure to prevent some kind of dead-lock
when the connection between the two machines dies.

This all works quite well, but after about 6~12 disconnects and
reconnects of the nbd (disc-failures for the raid) while the recovery
thread is working, the recovery thread is show as folling in
/proc/mdstat:
|     [>....................]  recovery =  0.0% (0/16777152)
|     finish=461360.7min speed=0K/sec

So there is no recovery :-(

I'm not shure whether this only happens if there is write activity on
the raid, but in most cases there was. The recovery thread did never
complete because I disconnected after ~30s after reconnect.

mdrecoveryd and raid1d show up normal in top, they are just not running.

Not to forget, /proc/mdstat shows the recovery stats also when I remove
the disc again.

Is there any way to stop the recovery thread manually?

Regards,
Martin
