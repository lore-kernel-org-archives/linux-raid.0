From: Scott McDermott <vaxerdec@frontiernet.net>
Subject: Re: Mirroring swap
Date: Thu, 26 Jun 2003 05:46:55 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030626054655.Q9583@newbox.localdomain>
References: <Pine.LNX.4.44.0306251535120.16603-100000@gpu.utcc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0306251535120.16603-100000@gpu.utcc>; from dky@utcc.utoronto.ca on Wed, Jun 25, 2003 at 03:39:45PM -0400
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Derek Yeung on Wed 25/06 15:39 -0400:
> I was wondering if it's a good idea to also mirror the
> swap partition?  

You should definitely mirror swap or any dirty pages which
are swap-backed will be lost when the swap device dies,
resulting in data or filesystem corruption.  Not to mention
that your system will almost certainly crash when this
occurs.

> I was reading old posts in the newsgroups that suggest
> this may not be a good idea but i can't seem to find an
> answer as to why.

The old RAID code couldn't handle swap for some reason, but
that was fixed a long time ago.  I believe it had something
to do with deadlocking in a situation where the RAID code
needed memory for some dealings with the mirrored swap
device, but the memory couldn't be obtained without swapping
out, which as you can imagine would cause problems.  I think
they changed this by making the kinds of buffers used by
RAID in these situations to be pinned, but I don't know.

> If it's a good idea, can anyone suggest how i can do it?
> (mirror swap?)  I don't currently have it set up yet.

swapoff, mkraid, raidstart, mkswap, swapon, vi /etc/fstab
