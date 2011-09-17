From: Henti Smith <henti@geekware.co.za>
Subject: additional feature for linear
Date: Sat, 17 Sep 2011 09:12:46 +0200
Message-ID: <CAC_HdUr9DHt9uQGj=zJcgGvTknckfhyykDBX11XgX+wgOhHQUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good day,

I have an itch I'm hoping somebody can provide me information with to
scratch it. Please be patient, I'm not very well versed in  all the
technical information regarding RAID, so I'm still finding my way
around.

Lets start with the itch.

I'm looking for a way to take 3 drives and create one pool. This is
similar to linear mode, but in this case if a drive in the linear mode
fail the rest of the pool is intact and just the missing files are
removed from the "device"

From my reading it looks like linear mode is the most likely
candidate, but there is no guarantee that the remaining data will be
accessible.

"If one disk crashes you will most probably lose all your data. You
can however be lucky to recover some data, since the filesystem will
just be missing one large consecutive chunk of data"

Would it not be possible to add functions to linear mode to mark this
missing chunks as "bad blacks" and let the FS deal with it as such
thereby allowing you to mount the linear device as per normal and
still access the remaining data ?

Id this is not possible, is there not some other way to implement this ?

I see there is some mails regarding adding additional drives to linear
as well and that the correct way is to stop the linear array and
recreate it with additional drives. Is this correct ?

I also see there was work being done on extending the array while
online. Was this ever done ?

Regards
Henti
