From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: migration of raid 5 to raid 6 and disk of 2TB to 4TB
Date: Sat, 6 Aug 2016 19:04:03 +0100
Message-ID: <57A62693.5040209@youngman.org.uk>
References: <CADzS=aqYQEoqxHbp7keeuYqN2dLur1O=RfctfuFsraggxiWTKg@mail.gmail.com>
 <22423.44287.974770.114127@tree.ty.sabi.co.uk>
 <5797C5CE.6020300@youngman.org.uk>
 <CADzS=arvFWy-9_e8L3ngdrYxwGxVNm=zTqoLusvwKmmkUnBfQQ@mail.gmail.com>
 <22424.53061.186858.220134@tree.ty.sabi.co.uk>
 <CADzS=aqLeMibSf-=U1+-_pcoGDu043exZ9ytUR6XLUwZ=VDOWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADzS=aqLeMibSf-=U1+-_pcoGDu043exZ9ytUR6XLUwZ=VDOWw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: bobzer <bobzer@gmail.com>, Peter Grandi <pg@lxra2.to.sabi.co.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/08/16 00:32, bobzer wrote:
> thank you very much for all your help
> 
> I manage to borrow 2  3TB drive
> So i was thinking of dd copie my image to one, use the other to
> reconstruct my raid
> so at this point i got my first raid5 clean
> then i prepare my raid6 degraded with the the 3  4TB and do a rsync
> 
> another solution could be to move the image disk to one 3TB
> create the raid6 degraded with the 3 4TB
> move the image in the raid 6
> replace the 2 2TB with the 2 3TB (with a DD copy ?)
> reuse the 2 2TB to have a clean raid 6
> rsync from the degraded raid5 to the clean raid6
> 
> I prefere the first solution because the raid 5 is clean and so it
> should be safer but i worrying about the stress of rebuild the raid

Okay. So rebuilding a raid could tip it over the edge.

But you now have four spare drives. So the obvious solution is

create a new raid6 with 2 x 4TB and 2 x 3TB drives.
Copy from the old raid to the new one - the reads won't stress the old
raid anywhere near as much as a rebuild.
Replace one of the 3TB disks with the 4TB that's currently in the old raid.
Raid0 the 2 x 2TB disks from the old raid, and replace the second 3TB disk.

At no point are you rebuilding a degraded raid, and when your data is at
its greatest risk (no backup, raid reshaping) you have a raid6 so you
could survive a disk failure. Oh - and always use mdadm --replace so the
raid always has spare disks ...

If you want to do it in place, ddrescue the two 2TB drives on to the two
3TB drives, so again you can raid0 the 2 x 2TB together, but I think
that's still taking a risk.

Cheers,
Wol
