From: Dawning Sky <the.dawning.sky@gmail.com>
Subject: Disk I/O error while rebuilding an md raid-5 array
Date: Mon, 8 Feb 2010 15:23:54 -0800
Message-ID: <adf93d751002081523y1b9de656kdbba276b3dbc6af4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have some trouble with my md raid-5 array.  It has four 500GB drives
(sdb1-sde1).  sde started giving some SMART error (Pending Bad
Sectors).  So just to be safe, I decided to replace it.  I declared it
to be faulty and removed it from the array and added a new drive and
the rebuilding was automatic.  But before the rebuilding can finish, I
got an I/O error from sdb1 and it was declared faulty by md.

Now I have two faulty drives and things don't look good.  However, I
was able to add the sdb back to the array and md seemed not mind and
still reported "active sync".  At this point I shut down computer and
decided to clone sdb with clonezilla so that I can have a good sdb to
finish rebuilding sde.  Not sure if it will complete without I/O
errors.  It appears clonezilla is using dd and the speed is extremely
slow (~5MB/sec) and it says it's gonna take 1 day to clone the 500GB.

The only reason I'm not in a total panic mode is that I did a back up
before doing all this.  Now I'm keeping my finger crossed that my
backup drive won't die.  In retrospect, I should have just shut down
the computer and cloned sde instead of letting md to rebuild the
array.

Any suggestions on the best way to proceed at this point are highly
appreciated, especially on the scenario that I won't be able to clone
sdb.  Is there any way to avoid building a new array?

Regards,

DS

PS, if in the end I have to build a new array, I'll probably go with a
raid 6 instead.
