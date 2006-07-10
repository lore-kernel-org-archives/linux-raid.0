From: Karl Voit <neww@Karl-Voit.at>
Subject: Re: only 4 spares and no access to my data
Date: Mon, 10 Jul 2006 07:56:17 +0000 (UTC)
Message-ID: <loom.20060710T095111-275@post.gmane.org>
References: <loom.20060709T205013-455@post.gmane.org> <62b0912f0607091223y3d0a1ab5xbc5fb01ce2a74f9e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Molle Bestefich <molle.bestefich <at> gmail.com> writes:

> From the paste bin:
> 
> > 443: root <at> ned ~ # mdadm --examine /dev/sd[abcd]
> 
> Shows that all 4 devices are ACTIVE SYNC....

Please note that there is no "1" behind sda up to sdd!

> Then:
> 
> > 568: root <at> ned ~ # mdadm --examine /dev/sd[abcd]1
> 
> Suddenly shows all 4 devices as SPARE?

Now these are the sda1 up to sdd1 (with "1"!).

Probably the superblocks are damaged or wrong?

> > mdadm-version: 1.12.0-1
> > uname: Linux ned 2.6.13-grml
> 
> You should probably upgrade at some point, there's always a better
> chance that devels will look at your problem if you're running the
> version that they're sitting with..

Good point.
 
> Running zero-superblock on "sd[abcd]" and then assembling the array
> from "sd[abcd]_1_" sounds odd to me.

Well this is because of the false(?) superblocks of sda-sdd in comparison to
sda1 to sdd1.


