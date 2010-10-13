From: greg@enjellic.com
Subject: Complexity of toggling write-behind.
Date: Wed, 13 Oct 2010 13:48:50 -0500
Message-ID: <201010131848.o9DImoXe007448@wind.enjellic.com>
Reply-To: greg@enjellic.com
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil/linux-raid, hope the week is going well for everyone.

We implement a lot of geographically mirrored storage using Linux
RAID1 on the 'front-side' to access Linux servers running SCST for
storage backends.  One of the issues we are addressing are methods to
reduce I/O latency from the initiator's perspective when various
housekeeping operations are being done on the Linux backends, ie. RAID
check operations/re-synchronizations.

Write-mostly support is very helpful for reducing any read latencies.
To fully complete the loop it would be useful to leverage asynchronous
write-behind to eliminate write latency effects.  We use write-intent
bitmaps on the initiators so we are already preparted for that.

It is straight forward to toggle writemostly via the
/sys/mdN/md/rN/state pseudofiles but a review of the MD driver code in
at least 2.6.32.16 would suggest that write-behind is not readily
togglable.  That may have changed in most recent kernels but I don't
remember seeing any changelogs with your 'git pull' requests which
would suggest that.

Is this a function of support being a can of worms or just lack of
cycles?  If it is the latter I would be willing to take some
directional suggestions and see if we could get a prototype
implementation up and running.

Thanks much for any insight you may have.

Best wishes for a productive remainder of the week.

As always,
Dr. G.W. Wettstein, Ph.D.   IDfusion.org
4206 N. 19th Ave.           Unified health identity architecture.
Fargo, ND  58102
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@idfusion.org
------------------------------------------------------------------------------
"We don't know the OS that God uses, but the Vatican uses Linux."
                                -- Sister Judith Zoebelein
                                   Vatican Webmaster
