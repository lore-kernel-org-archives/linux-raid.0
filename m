From: Jan Ceuleers <jan.ceuleers@computer.org>
Subject: [Fwd: Spares not automatically added on boot]
Date: Mon, 09 Feb 2009 20:20:13 +0100
Message-ID: <499081ED.4060000@computer.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bumping. Sorry 'bout that, but I would like to give this another chance 
at attracting attention.

Many thanks, Jan

-------- Original Message --------
Date: Sun, 01 Feb 2009 13:10:04 +0100
From: Jan Ceuleers <jan.ceuleers@computer.org>
To: linux-raid@vger.kernel.org
Subject: Spares not automatically added on boot

All,

I've been having a long-standing problem with spares not being
automatically re-added to my raid sets when the system is booted. I
reported this problem here:

https://bugs.launchpad.net/ubuntu/+source/mdadm/+bug/252365

The problem appears to be that if spare drives are served by a disk
controller that is of another type than the one serving the active
volumes, then the modules for both types of disk controller need to be
included in the initrd image for things to work properly. This is on
Ubuntu 7.10 and 8.04.

I'd be interested in views here as to the real root cause (since the fix
that works for me and for one other user may not a generic fix).

Thanks, Jan

