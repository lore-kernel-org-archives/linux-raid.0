From: klink@clouddancer.com (Colonel)
Subject: (unknown)
Date: Sun,  2 Jun 2002 15:08:47 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020602220847.5EC548347@phoenix.clouddancer.com>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Colonel <klink@clouddancer.com>
To: linux-raid@vger.kernel.org
In-reply-to: <023701c20a2d$9f8fc240$6401a8c0@cfl.rr.com> (mblack@csihq.com)
Subject: OOPS on raidtools-20010914
Reply-to: klink@clouddancer.com
References: <20020602112056.2FEB38347@phoenix.clouddancer.com> <023701c20a2d$9f8fc240$6401a8c0@cfl.rr.com>


   From: "Mike Black" <mblack@csihq.com>
   Date: Sun, 2 Jun 2002 08:04:17 -0400

Thanks for the reply.

   Either copy /usr/lib/libpopt* to /lib or add a -static switch to the Makefile to compile the utilities.
   One of the problems of shared libraries....

Well, actually I'm wondering why -static is not already present.
These tools reside in /sbin after all.

   And...as long as you have stripes compiled into the kernel and partition type 0xfd it should autostart (I'm pretty sure stripes
   should do that too -- I don't use them).  That would also solve
   your problem.

Ah, no.  Striped mirrors have stripes made from meta-devices.  The
mirrors autostart fine.


   And while you're upgrading why don't you use the latest (it's called mdadm now)?
   http://www.cse.unsw.edu.au/~neilb/source/mdadm/

I know raidtools has worked in the past, this is a production system
and I have nothing to experiment upon.  So I looked in mingos
directory...will look at this site.


   ----- Original Message -----
   From: "Colonel" <klink@clouddancer.com>
   To: <linux-raid@vger.kernel.org>
   Sent: Sunday, June 02, 2002 7:20 AM


   > To: linux-raid@vger.kernel.org
   > Subject: OOPS on raidtools-20010914
   > Reply-to: klink@clouddancer.com
   > From: Colonel <klink@clouddancer.com>
   >
   >
   > I recently switched to these tools, I'd been using the 1999 ones
   > previously.  I run striped mirrors for /usr, I must (apparently)
   > manually start that meta-device as part of the startup scripts.  So
   > having raidstart and all it's pieces on the / partition is pretty
   > important.  Imagine my fun after a reboot told me that lilpopt was
   > unavailable for raidstart, thus I had no /usr and no way to do
   > anything about it within this machine (because libpopt is stored in
   > /usr/lib).  Fortunately, I had not upgraded all the other machines to
   > these newer tools.
   >
   > Perhaps libpopt is misplaced on my system, or perhaps the raidtool
   > makefile doesn't expect a manual start raid array....
   >
   > Any solutions?
   >
   > Ron
   > -
   > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
   > the body of a message to majordomo@vger.kernel.org
   > More majordomo info at  http://vger.kernel.org/majordomo-info.html
   >

