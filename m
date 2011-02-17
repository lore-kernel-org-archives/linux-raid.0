From: Phil Turmel <philip@turmel.org>
Subject: Re: Mixing mdadm versions
Date: Thu, 17 Feb 2011 08:25:14 -0500
Message-ID: <4D5D21BA.6060804@turmel.org>
References: <AANLkTi=g2V9n_AEEGX58d1PkTLRj7HtxT=AGEaLQXNz1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=g2V9n_AEEGX58d1PkTLRj7HtxT=AGEaLQXNz1@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hansbkk@gmail.com
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/17/2011 05:21 AM, hansbkk@gmail.com wrote:
> I've created and manage sets of arrays with mdadm v3.1.4 - I've been
> using System Rescue CD and Grml for my sysadmin tasks, as they are
> based on fairly up-to-date gentoo and debian and have a lot of
> convenient tools not available on the production OS, a "stable" (read:
> old packages) flavor of RHEL, which turns out is running mdadm v2.6.4.
> I spec'd v1.2 metadata for the big raid6 storage arrays, but kept to
> 0.90 for the smaller raid1's as some of those are my boot devices.

The default data offset for for v1.1 and v1.2 meta-data changed in mdadm v3.1.2.  If you ever need to use the running system to "mdadm --create --assume-clean" in a recovery effort, the data segments will *NOT* line up if the original array was created with a current version of mdadm.

(git commit a380e2751efea7df "super1: encourage data alignment on 1Meg boundary")

> As per a previous thread, I've noticed on the production OS the output
> of mdadm -E on a member returns a long string of "failed, failed". The
> more modern mdadm reports everything's OK.
> 
> - Also mixed in are some "fled"s - whazzup with that?
> 
> Unfortunately the server is designed to run as a packaged appliance
> and uses the rpath/conary package manager, so I'm hesitant to fiddle
> around upgrading some bits, afraid that other bits will break - the
> sysadmin tools are run from a web interface to a bunch of PHP scripts.
> 
> So, here are my questions:
> 
> As long as the more recent versions of mdadm report that everything's
> OK, can I ignore the mishmosh output of the older mdadm -E report?

Don't know.

> And am I correct in thinking that from now on I should create
> everything with the older native packages that are actually going to
> serve the arrays in production?

If there's a more modern Red Hat mdadm package that you can include in your appliance, that would be my first choice.  After testing with the web tools, though.

Otherwise, I would say "Yes", for the above reason.  However, the reverse problem can also occur.  You won't be able to use a modern mdadm to do a "--create --assume-clean" on an offline system.  That's what happened to Simon in another thread.  Avoiding that might be worth the effort qualifying a newer version of mdadm.

Phil
