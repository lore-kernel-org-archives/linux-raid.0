From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: let md auto-detect 128+ raid members, fix potential race condition
Date: Tue, 01 Aug 2006 12:28:12 +0400
Message-ID: <44CF109C.7060008@tls.msk.ru>
References: <ork65veg2y.fsf@free.oliva.athome.lsd.ic.unicamp.br>	<20060730124139.45861b47.akpm@osdl.org>	<orac6qerr4.fsf@free.oliva.athome.lsd.ic.unicamp.br>	<17613.16090.470524.736889@cse.unsw.edu.au>	<ord5blcyg0.fsf@free.oliva.athome.lsd.ic.unicamp.br>	<44CE7A9B.8020508@dgreaves.com> <oru04xrych.fsf@free.oliva.athome.lsd.ic.unicamp.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <oru04xrych.fsf@free.oliva.athome.lsd.ic.unicamp.br>
Sender: linux-raid-owner@vger.kernel.org
To: Alexandre Oliva <aoliva@redhat.com>
Cc: David Greaves <david@dgreaves.com>, Neil Brown <neilb@suse.de>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Alexandre Oliva wrote:
[]
> If mdadm can indeed scan all partitions to bring up all raid devices
> in them, like nash's raidautorun does, great.  I'll give that a try,

Never, ever, try to do that (again).  Mdadm (or vgscan, or whatever)
should NOT assemble ALL arrays found, but only those which it has
been told to assemble.  This is it again: you bring another disk into
a system (disk which comes from another machine), and mdadm finds
FOREIGN arrays and brings them up as /dev/md0, where YOUR root
filesystem should be.  That's what 'homehost' option is for, for
example.

If initrd should be reconfigured after some changes (be it raid
arrays, LVM volumes, hostname, whatever), -- I for one am fine
with that.  Hopefully no one will argue that if you forgot to
install an MBR into your replacement drive, it was entirely your
own fault that your system become unbootable, after all ;)

/mjt
