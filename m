From: bobzer <bobzer@gmail.com>
Subject: Re: migration of raid 5 to raid 6 and disk of 2TB to 4TB
Date: Fri, 5 Aug 2016 19:32:57 -0400
Message-ID: <CADzS=aqLeMibSf-=U1+-_pcoGDu043exZ9ytUR6XLUwZ=VDOWw@mail.gmail.com>
References: <CADzS=aqYQEoqxHbp7keeuYqN2dLur1O=RfctfuFsraggxiWTKg@mail.gmail.com>
 <22423.44287.974770.114127@tree.ty.sabi.co.uk> <5797C5CE.6020300@youngman.org.uk>
 <CADzS=arvFWy-9_e8L3ngdrYxwGxVNm=zTqoLusvwKmmkUnBfQQ@mail.gmail.com> <22424.53061.186858.220134@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22424.53061.186858.220134@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.to.sabi.co.uk>, Wols Lists <antlists@youngman.org.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

thank you very much for all your help

I manage to borrow 2  3TB drive
So i was thinking of dd copie my image to one, use the other to
reconstruct my raid
so at this point i got my first raid5 clean
then i prepare my raid6 degraded with the the 3  4TB and do a rsync

another solution could be to move the image disk to one 3TB
create the raid6 degraded with the 3 4TB
move the image in the raid 6
replace the 2 2TB with the 2 3TB (with a DD copy ?)
reuse the 2 2TB to have a clean raid 6
rsync from the degraded raid5 to the clean raid6

I prefere the first solution because the raid 5 is clean and so it
should be safer but i worrying about the stress of rebuild the raid

i like the second solution because i don't need to rebuild the raid 5
and so i don't take the risk that my 2T disk died
I mean, they should be ok but i prefere to just have to read on them
than to write for the rebuild (last time it's the stress of the
rebuild which destroy my raid...)
the interest is that there if one 2TB died it more likely to happend
when is in the raid 6 not when i read from them to copy in the 3T, and
when my data are in 3tb they should be safe

there is plenty more solution available to me now that i got these 2
drives except that i have to give then back as soon as possible

anyway i still don't know which scenario is the best

but thanks for your help
