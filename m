From: Mike Dresser <mdresser_l@windsormachine.com>
Subject: Re: raid 0 on different size devices?
Date: Wed, 19 Nov 2003 14:24:21 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0311191423310.29842@router.windsormachine.com>
References: <Pine.LNX.4.44.0311191154050.5855-100000@eglifamily.dnsalias.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0311191154050.5855-100000@eglifamily.dnsalias.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Wed, 19 Nov 2003, Dan Egli wrote:

> Can the linux Software Raid handle devices of differing size? Basically my
> issue is this: I've got two drives, a 27GB and a 40GB. I really want to
> get them accessed as a single device. Is it possible to stack these drives
> using like a raid 0?

Yes.  Years and years ago I did this with 10 drives (6 scsi, and 4 ide).

Remember that a drive failure on any disk is going to trash the entire
array.

There's also a linear raid mode that works the same basic idea as raid0,
in Linux.

Mike
