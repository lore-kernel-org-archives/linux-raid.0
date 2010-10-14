From: Andrew Klaassen <clawsoon@yahoo.com>
Subject: Re: Preventing a RAID device from starting until all disks are ready
Date: Thu, 14 Oct 2010 10:00:32 -0700 (PDT)
Message-ID: <550140.97538.qm@web65408.mail.ac4.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--- On Thu, 10/14/10, Iordan Iordanov <iordan@cdf.toronto.edu>  wrote:

> Have you considered enabling a write-intent bitmap on your
> array? This way, at least your rebuild will take seconds
> instead of 10 hours. Write intent bitmap support for RAID10
> was introduced in 2005, and hopefully CentOS 5.2 supports
> it.

I've never heard of that - sounds fantastic.  Does it have any performance penalties during heavy writes?

> We have iscsi targets for drives in our array, and we make
> sure that we've logged into all 30 of our drives before we
> continue to enable mdadm (we literally count the number of
> iscsi sessions open). You can try counting the number of
> block devices present (in /dev/block) that match a certain
> pattern, or perhaps your fiber channel driver offers an even
> more convenient facility in /dev.

Are you doing the mdadm startup in rc.local, or in the initrd, or...?

Andrew


