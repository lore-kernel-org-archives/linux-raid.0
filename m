From: Andi Kleen <andi@firstfloor.org>
Subject: Re: XFS on x86_64 Linux Question
Date: 28 Apr 2007 19:32:11 +0200
Message-ID: <p73lkgc1k2s.fsf@bingen.suse.de>
References: <Pine.LNX.4.64.0704280633510.7998@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <xfs-bounce@oss.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0704280633510.7998@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com, linux-raid@linux-kernel.vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz <jpiszcz@lucidpixels.com> writes:

> Had a quick question, if I re-provision a host with an Intel Core Duo
> CPU with x86_64 Linux; I create a software raid array and use the XFS
> filesystem-- all in 64bit space...
> 
> If I boot a recovery image such as Knoppix, it will not be able to
> work on the filesystem correct?  I would need a 64bit live CD?

There used to be a XFS bug that 32bit journals couldn't 
be replayed on 64bit and vice versa. This means you couldn't mount
a dirty file system on the other architecture. But this bug has been 
long fixed and mounting clean file systems always worked.

-Andi
