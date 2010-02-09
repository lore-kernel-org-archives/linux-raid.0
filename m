From: Dawning Sky <the.dawning.sky@gmail.com>
Subject: Re: Disk I/O error while rebuilding an md raid-5 array
Date: Mon, 8 Feb 2010 20:20:17 -0800
Message-ID: <adf93d751002082020t642cb1d3ne3d3f5fe5d57e7b5@mail.gmail.com>
References: <adf93d751002081523y1b9de656kdbba276b3dbc6af4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <adf93d751002081523y1b9de656kdbba276b3dbc6af4@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Feb 8, 2010 at 3:23 PM, Dawning Sky <the.dawning.sky@gmail.com>=
 wrote:
> Hi,
>
> Now I have two faulty drives and things don't look good. =A0However, =
I
> was able to add the sdb back to the array and md seemed not mind and
> still reported "active sync". =A0At this point I shut down computer a=
nd
> decided to clone sdb with clonezilla so that I can have a good sdb to
> finish rebuilding sde. =A0Not sure if it will complete without I/O
> errors. =A0It appears clonezilla is using dd and the speed is extreme=
ly
> slow (~5MB/sec) and it says it's gonna take 1 day to clone the 500GB.
>

As expected, dd encountered the same UNC error.  Now I'm trying to
ddrescue the drive to see what happens.  My question is whether this
is worth doing.  Assuming ddrescue cannot read the bad sector either
and writes 0's to the new drive, will I be able to rebuild the raid-5,
from 2 good disks and this disk with a bad sector?  I can assume there
will be a bad file but will the array still function?

Or I'm better off just build a new array from scratch.

Any suggestions are appreciated.

Regards,

DS
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
