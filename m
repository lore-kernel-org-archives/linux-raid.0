From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: [PATCH] proactive raid5 disk replacement for 2.6.11
Date: Mon, 22 Aug 2005 12:47:27 +0200
Message-ID: <62b0912f0508220347135352ea@mail.gmail.com>
References: <1124050204.3810.28.camel@localhost.localdomain>
	 <C0A1E607B5206F88D89CAF42@192.168.1.22>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C0A1E607B5206F88D89CAF42@192.168.1.22>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Claas Hilbrecht <claas+maillinglists.linux-raid@jucs-kramkiste.de>, Pallai Roland <dap@mail.index.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Claas Hilbrecht wrote:
> Pallai Roland schrieb:
> >  this is a feature patch that implements 'proactive raid5 disk
> > replacement' (http://www.arctic.org/~dean/raid-wishlist.html),
> 
> After my experience with a broken raid5 (read the list) I think the
> "partially failed disks" feature you describe is really useful. I agree
> with you that this kind of error is rather common.

Horrible idea.
Once you have a bad block on one disk, you have definitively lost your
data redundancy.
That's bad.

What should be done about bad blocks instead of your suggestion is to
try and write the data back to the bad block before kicking the disk. 
If this succeeds, and the data can then be read from the failed block,
the disk has automatically reassigned the sector to the spare sector
area.  You have redundancy again and the bad sector is "fixed".

If you're having a lot of problems with disks getting kicked because
of bad blocks, then you need to diagnose some more to find out what
the actual problem is.

My best guess would be that either you're using an old version of MD
that won't try to write to bad blocks, or the spare area on your disk
is full, in which case it should be replaced.  You can check the
status of spare areas on disks with 'smartctl' or similar.
