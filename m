From: Jon Lewis <jlewis@lewis.org>
Subject: Re: what is the best multi-SATA-controller-on-a-single-board out
 there?
Date: Mon, 2 Aug 2004 17:09:36 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0408021700230.7852@web1.mmaero.com>
References: <20040730234706.M12321@contactbda.com>
 <Pine.LNX.4.44.0407311045460.4528-100000@uplift.swm.pp.se>
 <20040801150258.M30882@contactbda.com> <1091382829.11770.14.camel@tinny.home.foo>
 <410E15EB.7030407@buttersideup.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <410E15EB.7030407@buttersideup.com>
To: Tim Small <tim@buttersideup.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2 Aug 2004, Tim Small wrote:

> The Promise cards, are cheap, but only do 66Mhz/32 bit PCI and provide
> four SATA ports, so they may not be well suited to some boards..  Both
> chipsets were used with libata on 2.6 kernels, with a mixture of s/w
> raid5, and s/w raid1.  The only slight irritation is the current lack of
> smartd support (pending libata driver support).

With what distros / exactly which kernels?  I've been testing a system
with 2 Promise SATA150 TX4's and 6 Maxtor 200gb SATA drives in a
supermicro (mb/chassis) system with 7 drive hot-swap drive carrier.  I've
been having serious problems and am having trouble telling if its hardware
or software.  I've been trying both Whitebox (basically RH ES 3.0 which
uses a 2.4 kernel and includes libata but doesn't build it by default) and
Fedora Core 2, which supports the SATA hardware by default.  OS gets
installed on smaller drives on the MB's PATA controller.  The big 6
drives are supposed to be SW RAID5.  The system usually locks up while
building the array.  Today it got as far as nearly finishing the mke2fs on
the array when it locked up.

Running badblocks on each 200gb drive individually, I got errors on one of
them once.  When I reran badblocks on that drive, I did not get errors.
I still can't get an array built/formatted (under whitebox today) without
the system locking up.

So, I'm curious who else is using the SATA150 TX4 and with which
kernel/driver and whether they're having or have seen any similar
problems.


----------------------------------------------------------------------
 Jon Lewis                   |  I route
 Senior Network Engineer     |  therefore you are
 Atlantic Net                |
_________ http://www.lewis.org/~jlewis/pgp for PGP public key_________
