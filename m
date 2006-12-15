From: Nikolai Joukov <kolya@cs.sunysb.edu>
Subject: Re: [ANNOUNCE] RAIF: Redundant Array of Independent Filesystems
Date: Fri, 15 Dec 2006 11:48:40 -0500 (EST)
Message-ID: <Pine.GSO.4.53.0612151138360.26813@compserv1>
References: <Pine.GSO.4.53.0612122217360.22195@compserv1>
 <200612132257.24399.a1426z@gawab.com> <Pine.GSO.4.53.0612141538410.6095@compserv1>
 <200612151030.31846.manningc2@actrix.gen.nz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <200612151030.31846.manningc2@actrix.gen.nz>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Charles Manning <manningc2@actrix.gen.nz>
Cc: Al Boldi <a1426z@gawab.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> On Friday 15 December 2006 10:01, Nikolai Joukov wrote:
> > > Nikolai Joukov wrote:
> > > > We have designed a new stackable file system that we called RAIF:
> > > > Redundant Array of Independent Filesystems.
> > >
> > > Great!
>
> Yes, definitely...
>
> I see the major benefit being in the mobile, industrial and embedded systems
> arena. Perhaps this might come as a suprise to people, but a very large and
> ever growing number (perhaps even most) Linux devices don't use block devices
> for storage. Instead they use flash file systems or nfs, niether of which use
> local block devices.
>
> It looks like RAIF gives a way to provide redundancy etc on these devices.

Good point!  Also, RAIF can store different file types differently.
Therefore, it is possible to mount RAIF over file systems with lots of
storage space and a flash file system (with usually less space).  In this
case, RAIF can be configured to use flash to keep replicas of the most
important data only.   And yes, thanks to the stackable nature of RAIF no
explicit flash support is required.  RAIF can reuse existing file systems
designed for flash media (e.g., JFFS2).

Nikolai.
