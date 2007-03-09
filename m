From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: Raid 10 Problems?
Date: Thu, 8 Mar 2007 16:58:03 -0800 (PST)
Message-ID: <464915.77231.qm@web52507.mail.yahoo.com>
References: <45F09698.7090606@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S2992823AbXCIA6I@vger.kernel.org>
In-Reply-To: <45F09698.7090606@tls.msk.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>, Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: dean gaudet <dean@arctic.org>, Marc Perkel <mperkel@yahoo.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--- Michael Tokarev <mjt@tls.msk.ru> wrote:

> Jan Engelhardt wrote:
> []
> > The other thing is, the bitmap is supposed to be
> written out at intervals,
> > not at every write, so the extra head movement for
> bitmap updates should
> > be really low, and not making the tar -xjf process
> slower by half a minute.
> > Is there a way to tweak the write-bitmap-to-disk
> interval? Perhaps 
> > something in /sys or ye olde /proc. Maybe
> linux-raid@ knows 8)
> 
> Hmm.  Bitmap is supposed to be written before actual
> data write, to mark
> the to-be-written areas of the array as "being
> written", so that those
> areas can be detected and recovered in case of power
> failure during
> actual write.
> 
> So in case of writing to a clean array, head
> movement always takes place -
> first got to bitmap area, and second to the actual
> data area.
> 
> That "written at intervals" is about clearing the
> bitmaps after some idle
> time.
> 
> In other words, dirtying bitmap bits occurs right
> before actual write,
> and clearing bits occurs at intervals.
> 
> Sure, if you write to (or near) the same place again
> and again, without
> giving a chance to md subsystem to actually clean
> the bitmap, there will
> be no additional head movement.  And that means, for
> example, tar -xjf
> sometimes, since filesystem will place the files
> being extracted close to
> each other, thus hitting the same bit in the bitmap,
> hence md will skip
> repeated bitmap updates in this case.
> 
> /mjt
> 

I assume that if a block is already dirty then that is
cached somewhere in memory so you aren't writing to
the bitmap unless you're changing it for clean to
dirty? If that's the case then I would think that
writing to the map wouldn't be that expensive?



 
____________________________________________________________________________________
Now that's room service!  Choose from over 150,000 hotels
in 45,000 destinations on Yahoo! Travel to find your fit.
http://farechase.yahoo.com/promo-generic-14795097
