From: Sean Puttergill <puttergi@yahoo.ca>
Subject: Re: Auto-assembling arrays using mdadm
Date: Thu, 9 Mar 2006 14:23:34 -0500 (EST)
Message-ID: <20060309192334.12864.qmail@web35314.mail.mud.yahoo.com>
References: <Pine.LNX.4.64.0603090939410.32502@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0603090939410.32502@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

As far as I know, "mdadm --assemble --scan" requires
that there be ARRAY lines in the mdadm.conf file. 
These lines must list the device node and the UUID of
the array at a minimum.

What I want to achieve is to automatically inspect a
set of disks and start all the RAID arrays found
without the need for any a priori information in the
mdadm.conf file.  I.e. with mdadm.conf as follows:

"
DEVICE /dev/sd*
"

This is the kind of functionality provided by kernel
RAID autodetect.  You don't have to have any config
information provided in advance.  The kernel finds and
assembles all arrays on disks with RAID autodetect
partition type.  I want to do the same thing, but with
mdadm.

Perhaps I am confused.  Has this changed in 2.x?  I am
using version 1.11.0


Sean

--- dean gaudet <dean@arctic.org> wrote:

> On Thu, 9 Mar 2006, Sean Puttergill wrote:
> 
> > Hi.
> > 
> > I am looking to script auto-assembly of all arrays
> > detected on an arbitrary set of drives using
> mdadm.
> > 
> > The way I am thinking of doing this is as follows:
> > 
> > mdadm.conf =
> > 
> > DEVICE /dev/sd*
> 
> i prefer to use "DEVICE partitions"
> 
> > 1. Use "mdadm -E" on each drive in turn to get the
> > UUID for the array to which it belongs and
> assemble a
> > list of unique UUIDs.
> > 
> > 2. Run "mdadm -A --uuid=<UUID> --auto=md --scan"
> for
> > each unique UUID.
> > 
> > 
> > My question is, is it currently possible for me to
> get
> > mdadm to do this automatically?
> 
> the man page has an example... it's just:
> 
> 	mdadm --assemble --scan
> 
> -dean
> 


__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
