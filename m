From: Alexandre Oliva <aoliva@redhat.com>
Subject: modifying degraded raid 1 then re-adding other members is bad
Date: Tue, 08 Aug 2006 06:38:19 -0300
Message-ID: <or8xlztvn8.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Assume I have a fully-functional raid 1 between two disks, one
hot-pluggable and the other fixed.

If I unplug the hot-pluggable disk and reboot, the array will come up
degraded, as intended.

If I then modify a lot of the data in the raid device (say it's my
root fs and I'm running daily Fedora development updates :-), which
modifies only the fixed disk, and then plug the hot-pluggable disk in
and re-add its members, it appears that it comes up without resyncing
and, well, major filesystem corruption ensues.

Is this a known issue, or should I try to gather more info about it?

This happened with 2.6.18rc3-git[367] (not sure which), plus Fedora
development patches.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
Secretary for FSF Latin America        http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
