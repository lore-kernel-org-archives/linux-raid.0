From: Mikhail Yakshin <greycat.na.kor@gmail.com>
Subject: [ANNOUNCE] Einarc - universal RAID management/monitoring tool -
	v1.4rc
Date: Thu, 2 Jul 2009 10:53:42 +0400
Message-ID: <240e377b0907012353n2718eda6sea6fe1dfb6021b97@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

After yet another more than half-a-year development cycle, I'd like to
introduce a release candidate of Einarc v1.4. "Final" version is
scheduled to be released in about a week: our team currently works on
a NAS project that uses Einarc extensively and Einarc v1.4 final would
be released simultaneously with a first semi-public preview release of
this NAS project.

Einarc is a universal storage RAID command line interface and an API
that provides management for various hardware/software RAID devices,
uniting them all in a single paradigm. Einarc works as a translator
that makes it possible for a user to control all these devices using
simple terms like "physical disc", "logical disc", "adapter", etc.,
while transparently converting these requests to proprietary RAID
paradigms.

It's mostly useful for hardware RAIDs, so practicing system
administrators may skip downloading and dealing with proprietary CLIs
themselves and use unified Einarc's interface. It can be also useful
for simplified software RAID management (as a wrapper for mdadm).

Version 1.4 focus points are:

* Support for post-build reconfiguration of proprietary CLIs and
supporting modules. This allows Einarc to be supplied via usual binary
packaging methods (rpm/deb): proprietary CLIs can be installed after
binary package installation using special setup tool =E2=80=9Ceinarc-in=
stall=E2=80=9D.
At least one Linux distribution - ALT Linux (http://www.altlinux.com/)
- already ships Einarc's RPM.

* Experimental support for hardware RAID autodetection in both
build-time (configure) and run-time (einarc-install). This feature
ultimately leads to a simplest deployment possible for an end-user:
just install an rpm/deb package and run "einarc-install
--modules=3Dauto" and that's it. Minimal download follows and Einarc's
ready to go.

* Many stability fixes and bug fixes.

Einarc can be downloaded at

http://www.inquisitor.ru/doc/einarc/?_openstat=3DbGludXgtcmFpZDsxLjRyYz=
s7

Einarc is a part of Inquisitor Linux stress testing and benchmarking
platform, where it's extensively used to test disc arrays, and being a
part of upcoming user-friendly NAS system.

As always, I would be very glad to hear any comments on these release,
bug reports, feature requests, etc.

--=20
WBR, Mikhail Yakshin
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
