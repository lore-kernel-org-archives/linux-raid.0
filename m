From: Gordon Henderson <gordon@drogon.net>
Subject: RE: raidtools vs mdadm
Date: Wed, 1 Sep 2004 07:45:24 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0409010739570.27250@lion.drogon.net>
References: <200408311927.i7VJRi311085@watkins-home.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200408311927.i7VJRi311085@watkins-home.com>
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 31 Aug 2004, Guy wrote:

> As I understand it, raidtools is not supported anymore.  The gods of RAID
> support mdadm.  I get this info from this list.
>
> RedHat 9 still uses raidtools.  I don't know about the newer versions of
> redhat.  RedHat, you there?  Please use mdadm!  I don't know what other
> distributions use.  I plan to give Debian a try the next time I setup a
> system.

Debian Woody supplies both raidtools and mdadm - it's up to you which
package you install. For the past 5-6 years, I've been using raidtools, as
thats all I've had avalable, so I understand them well and still use them.
However, I'm looking at mdadm for future builds and have just installed it
on one of my servers (which I've already built with raidtools)

Woody can't create RAID sets during install time, but I understand the new
Debian (Sarge) installer is avalable now for testing which does
incorporate this feature.

> People have posted patches to remove raidstart from the startup scripts, and
> replace them with mdadm.

Just don't install raidtools - by the looks of the startup scripts they
are multually exclusive anyway, but I've patched the mdadm-raid startup to
not execute on my local server (not strictly neccessary anyway as I'm
using the auto start (0xFD) feature anyway) This is more or less essential
to boot off RAID1 as far as I can tell.

Gordon
