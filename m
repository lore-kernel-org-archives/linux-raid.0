From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID1 assembly requires manual "mdadm --run"
Date: Fri, 8 Jul 2005 21:42:58 +1000
Message-ID: <17102.26306.174427.502866@cse.unsw.edu.au>
References: <200506261621.01799.mlaks@verizon.net>
	<62b0912f05070623185b90e732@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Molle Bestefich on Thursday July 7
Sender: linux-raid-owner@vger.kernel.org
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday July 7, molle.bestefich@gmail.com wrote:
> Mitchell Laks wrote:
> > However I think that raids should boot as long as they are intact, as a matter
> > of policy. Otherwise we lose our  ability to rely upon them for remote
> > servers...
> 
> It does seem wrong that a RAID 5 starts OK with a disk missing, but a
> RAID 1 fails.
> 
> Perhaps MD is unable to tell which disk in the RAID 1 is the freshest
> and therefore refuses to assemble any RAID 1's with disks missing?

This doesn't sound right at all.

"--run" is required to start a degraded array as a way of confirming
to mdadm that you really have listed all the drives available.
The normal way of starting an array at boot time is by describing the
array (usually by UUID) in mdadm.conf and letting mdadm find the
component devices with "mdadm --assemble --scan".

This usage does not require --run.

The only time there is a real reluctance to start a degraded array is
when it is raid5/6 and it suffered an unclean shutdown.
A dirty, degraded raid5/6 can have undetectably data corruption, and I
really want you to be aware of that and not just assume that "because
it started, the data must be OK".

NeilBrown
