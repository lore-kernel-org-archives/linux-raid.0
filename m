From: hansbkk@gmail.com
Subject: Mixing mdadm versions
Date: Thu, 17 Feb 2011 17:21:44 +0700
Message-ID: <AANLkTi=g2V9n_AEEGX58d1PkTLRj7HtxT=AGEaLQXNz1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I've created and manage sets of arrays with mdadm v3.1.4 - I've been
using System Rescue CD and Grml for my sysadmin tasks, as they are
based on fairly up-to-date gentoo and debian and have a lot of
convenient tools not available on the production OS, a "stable" (read:
old packages) flavor of RHEL, which turns out is running mdadm v2.6.4.
I spec'd v1.2 metadata for the big raid6 storage arrays, but kept to
0.90 for the smaller raid1's as some of those are my boot devices.

As per a previous thread, I've noticed on the production OS the output
of mdadm -E on a member returns a long string of "failed, failed". The
more modern mdadm reports everything's OK.

- Also mixed in are some "fled"s - whazzup with that?

Unfortunately the server is designed to run as a packaged appliance
and uses the rpath/conary package manager, so I'm hesitant to fiddle
around upgrading some bits, afraid that other bits will break - the
sysadmin tools are run from a web interface to a bunch of PHP scripts.

So, here are my questions:

As long as the more recent versions of mdadm report that everything's
OK, can I ignore the mishmosh output of the older mdadm -E report?

And am I correct in thinking that from now on I should create
everything with the older native packages that are actually going to
serve the arrays in production?
