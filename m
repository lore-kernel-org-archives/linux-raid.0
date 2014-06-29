From: =?UTF-8?Q?Nuno_Magalh=C3=A3es?= <nunomagalhaes@eu.ipp.pt>
Subject: Re: RAID newbie, 1 vs 5, chunk sizes
Date: Sun, 29 Jun 2014 14:22:00 +0100
Message-ID: <CADqA9uYpOahn8RAwQAtcnmDsWL4Y0TTOj6zBHvcK_shf8MgYuw@mail.gmail.com>
References: <CADqA9ua4xuJM3J6mQY7jXrt-5f6Rsv3aFaxyiqL1e80t70R6Rg@mail.gmail.com>
 <539E5504.1080809@turmel.org> <CADqA9ub=-=V_RMF+G2ZniQG06oDJ6KDhdPhDuPeufHFpgs4Mdw@mail.gmail.com>
 <2036850.atdiKx507N@eseries.newtech.fi> <CADNH=7E+xTPoM4LL_DJrpWxJjsw0aV_w7fVEosu1uc=1dsh16A@mail.gmail.com>
 <20140618233433.20b43198@natsu> <BLU436-SMTP21129DA8D8E77FBD7B995C898130@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU436-SMTP21129DA8D8E77FBD7B995C898130@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thank you all for the input.

As i now have 2x WD Red (5400rpm depending on whom you ask) and 2x
Toshiba DT01ACA100 (7200) it's not that feasible to set up a RAID5
array (otherwise it would be neat to benchmark it on Xen and compare
it with Mark Knecht's results).

So i'm opting for 2 RAID1 arrays, one for data with the WDs, another
for VMs and what not. I'll let the Debian installer decide on chunk
size and throw LVM on top of them.

And now i've been reading about ZFS, but i dislike the apparent memory
requirements for dom0 and it's not that native on Linux.

Cheers,
Nuno
