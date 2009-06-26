From: "Ron Lai" <ronlai@cs.stanford.edu>
Subject: Re: Questions regarding failure in the last IO path in multipath
Date: Thu, 25 Jun 2009 18:43:49 -0700
Message-ID: <154EADCFA8D54500B7E8CDD98B526E0E@FireEye.com>
References: <8733366C889641E8942BD8F6DC5DD876@FireEye.com> <da62ba781a117db1ba73ffc1e7a11189.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The changes are in multipath_error(). The diffs for /derivers/md/multipath.c 
are:

233,234c233
<                  /* leave it active... it's all we have */
<          } else {
---
>          }
252c251
<          }
---
>

Thanks.
----- Original Message ----- 
From: "NeilBrown" <neilb@suse.de>
To: "Ron Lai" <ronlai@cs.stanford.edu>
Cc: <linux-raid@vger.kernel.org>
Sent: Thursday, June 25, 2009 6:27 PM
Subject: Re: Questions regarding failure in the last IO path in multipath


On Fri, June 26, 2009 10:30 am, Ron Lai wrote:
> Hi,
> I use mdadm to setup multipath on a box running 2.6.25.14 and I try to
> simualte SAN failure by shutting down ports on the switch one by one.
> After
> I disable the last IO path, the box hangs with the following logs spewed
> out
> on the console.
>
> Jun 23 14:32:31 localhost kernel: multipath: sdn2: rescheduling sector 8
> Jun 23 14:32:31 localhost kernel: multipath: sdn: redirecting sector 48 to
> another IO path
> Jun 23 14:32:31 localhost kernel: multipath: sdn: redirecting sector
> 200015880 to another IO path
> Jun 23 14:32:31 localhost kernel: multipath: sdn: redirecting sector
> 200016408 to another IO path
> Jun 23 14:32:31 localhost kernel: multipath: sdn: redirecting sector
> 200114976 to another IO path
> Jun 23 14:32:31 localhost kernel: multipath: only one IO path left and IO
> error.
> Jun 23 14:32:31 localhost kernel: multipath: sdn2: rescheduling sector 56
> Jun 23 14:32:31 localhost kernel: multipath: only one IO path left and IO
> error.
> Jun 23 14:32:31 localhost kernel: multipath: sdn2: rescheduling sector
> 200015888
> Jun 23 14:32:31 localhost kernel: multipath: only one IO path left and IO
> error.
> Jun 23 14:32:31 localhost kernel: multipath: sdn2: rescheduling sector
> 200016416
> Jun 23 14:32:31 localhost kernel: multipath: only one IO path left and IO
> error.
> Jun 23 14:32:31 localhost kernel: multipath: sdn2: rescheduling sector
> 200114984
> Jun 23 14:32:31 localhost kernel: multipath: sdn: redirecting sector 0 to
> another IO path
> Jun 23 14:32:31 localhost kernel: multipath: sdn: redirecting sector 48 to
> another IO path
> Jun 23 14:32:31 localhost kernel: multipath: sdn: redirecting sector
> 200015880 to another IO path
> Jun 23 14:32:31 localhost kernel: multipath: sdn: redirecting sector
> 200016408 to another IO path
> Jun 23 14:32:31 localhost kernel: multipath: only one IO path left and IO
> error.
> Jun 23 14:32:31 localhost kernel: multipath: sdn2: rescheduling sector 8
> Jun 23 14:32:31 localhost kernel: multipath: only one IO path left and IO
> error.
> Jun 23 14:32:31 localhost kernel: multipath: sdn2: rescheduling sector 56
> Jun 23 14:32:31 localhost kernel: multipath: only one IO path left and IO
> error.
> Jun 23 14:32:31 localhost kernel: multipath: sdn2: rescheduling sector
> 200015888
> Jun 23 14:32:31 localhost kernel: multipath: only one IO path left and IO
> error.
> Jun 23 14:32:32 localhost kernel: multipath: sdn2: rescheduling sector
> 200016416
> Jun 23 14:32:32 localhost kernel: multipath: sdn: redirecting sector
> 200114976 to another IO path
> ........
>
>
> In multipath_error() in /derivers/md/multipath.c the code says that the
> last
> path never gets marked as faulty hence it keeps retrying. I've tried to
> change the code to allow the last path to be marked as faulty and the box
> seems to work okay after the failure in the last path. (The kernel spews
> out
> logs about inode errors. Nevertheless it stops eventually and mdadm shows
> that all the paths are marked as faulty.) Will this modification create
> problems in other parts of the kernel? Thanks.

Probably not, but it is hard to tell unless you post the actual patch.
Could you do that please?

Thanks,
NeilBrown

