From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Raid 10 Problems?
Date: Fri, 09 Mar 2007 02:04:56 +0300
Message-ID: <45F09698.7090606@tls.msk.ru>
References: <708349.8753.qm@web52513.mail.yahoo.com> <Pine.LNX.4.64.0703071010260.8538@twinlark.arctic.org> <Pine.LNX.4.61.0703080610580.2448@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0703080610580.2448@yvahk01.tjqt.qr>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: dean gaudet <dean@arctic.org>, Marc Perkel <mperkel@yahoo.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jan Engelhardt wrote:
[]
> The other thing is, the bitmap is supposed to be written out at intervals,
> not at every write, so the extra head movement for bitmap updates should
> be really low, and not making the tar -xjf process slower by half a minute.
> Is there a way to tweak the write-bitmap-to-disk interval? Perhaps 
> something in /sys or ye olde /proc. Maybe linux-raid@ knows 8)

Hmm.  Bitmap is supposed to be written before actual data write, to mark
the to-be-written areas of the array as "being written", so that those
areas can be detected and recovered in case of power failure during
actual write.

So in case of writing to a clean array, head movement always takes place -
first got to bitmap area, and second to the actual data area.

That "written at intervals" is about clearing the bitmaps after some idle
time.

In other words, dirtying bitmap bits occurs right before actual write,
and clearing bits occurs at intervals.

Sure, if you write to (or near) the same place again and again, without
giving a chance to md subsystem to actually clean the bitmap, there will
be no additional head movement.  And that means, for example, tar -xjf
sometimes, since filesystem will place the files being extracted close to
each other, thus hitting the same bit in the bitmap, hence md will skip
repeated bitmap updates in this case.

/mjt
