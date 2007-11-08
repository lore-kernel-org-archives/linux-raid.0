From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: Re: 2.6.23.1: mdadm/raid5 hung/d-state
Date: Thu, 8 Nov 2007 19:40:18 -0200
Message-ID: <18227.33346.994456.270194@fisica.ufpr.br>
References: <Pine.LNX.4.64.0711040658180.30831@p34.internal.lan>
	<18222.16003.92062.970530@notabene.brown>
	<Pine.LNX.4.64.0711041651250.23496@p34.internal.lan>
	<e9c3a7c20711051035m78ba90ck68f4fbc10480462a@mail.gmail.com>
	<Pine.LNX.4.64.0711051335450.11422@p34.internal.lan>
	<e9c3a7c20711051619u7054aab9l208b604b9e58fb61@mail.gmail.com>
	<47303FB8.7000801@systella.fr>
	<1194398700.2970.18.camel@dwillia2-linux.ch.intel.com>
	<47314653.80905@Lessem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47314653.80905@Lessem.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Lessem <Jeff@Lessem.org>, root@c3sl.ufpr.br
Cc: Dan Williams <dan.j.williams@intel.com>, =?UTF-8?B?QkVSVFJBTkQgSm/Dq2w=?= <joel.bertrand@systella.fr>, Justin Piszcz <jpiszcz@lucidpixels.com>, Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jeff Lessem (Jeff@Lessem.org) wrote on 6 November 2007 22:00:
 >Dan Williams wrote:
 > > The following patch, also attached, cleans up cases where the code looks
 > > at sh->ops.pending when it should be looking at the consistent
 > > stack-based snapshot of the operations flags.
 >
 >I tried this patch (against a stock 2.6.23), and it did not work for
 >me.  Not only did I/O to the effected RAID5 & XFS partition stop, but
 >also I/O to all other disks.  I was not able to capture any debugging
 >information, but I should be able to do that tomorrow when I can hook
 >a serial console to the machine.
 >
 >I'm not sure if my problem is identical to these others, as mine only
 >seems to manifest with RAID5+XFS.  The RAID rebuilds with no problem,
 >and I've not had any problems with RAID5+ext3.

Us too! We're stuck trying to build a disk server with several disks
in a raid5 array, and the rsync from the old machine stops writing to
the new filesystem. It only happens under heavy IO. We can make it
lock without rsync, using 8 simultaneous dd's to the array. All IO
stops, including the resync after a newly created raid or after an
unclean reboot.

We could not trigger the problem with ext3 or reiser3; it only happens
with xfs.
