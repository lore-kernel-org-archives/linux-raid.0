From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: migration of raid 5 to raid 6 and disk of 2TB to 4TB
Date: Mon, 25 Jul 2016 23:48:48 +0100
Message-ID: <57969750.5080804@youngman.org.uk>
References: <CADzS=aqYQEoqxHbp7keeuYqN2dLur1O=RfctfuFsraggxiWTKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADzS=aqYQEoqxHbp7keeuYqN2dLur1O=RfctfuFsraggxiWTKg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: bobzer <bobzer@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 25/07/16 22:14, bobzer wrote:
> Hi,
> 
> I'm looking for advice to not mess up my migration. because
> unfortunately i miss drive
> I wanna migrate all my data from a raid 5 of 4x2TB (actually 3 because
> i'm degraded right now) to a raid 6 of 4x4TB
> so exactly i got :
> - raid 5, should be 4 disk of 2T but got problem and so right now it's
> just 2x2T and a 2Tb disk image in a 4T disk (the raid crashed and is
> not start right now but is clean)
> - 2 disk of 4TB
> - the raid 5 use lvm2 on top of mdadm
> 
> I want a raid 6 so i thought i could create a raid 6 degraded with the
> 2x4TB and after copy the data to this new raid and after add the third
> 4TB and finally add the 2  2TB as a raid 0 to get a 4TB
> I know it's an ideal solution to get 3x4TB + 2x2TB to do my raid but
> it give me time to invest.
> 
> So my question is :
> - is it a really bad idea ?
> - do you have a better idea? solution ?
> - maybe i can migrate instead of copy a raid to another ?

Yup. You should be able to migrate.

Add in one of the 4TB drives as 4TB. It'll only use 2TB because it
matches the other drives, but it'll get your raid 5 back fully redundant.

Now replace the two 2TB drives with the 4TB drives. Use the --replace
option to mdadm - it's fairly new.

Then I think you'll have to fail the 2TB image in order to add the last
4TB drive in - maybe you won't - others might be able to help here ...
or you might be able to just remove the 2TB image and convert it to a
full raid 5 on 3 x 4TB disks - that's the best option if you can because
at no point are you surrendering a working raid and risking a failure.

(The thing to remember, is that raid will take the smallest drive, and
use that amount of space on all the drives. If you replace all the 2TBs
with 4TBs, suddenly the raid can use the full 4TB.)

Now you're using half your raid-space for your array, you should be able
to convert to raid 6, then expand the array to use the new space. I'm
not sure exactly how all this works, but having replaced all 2TB drives
with 4TB drives, I'm sure mdadm can claim the expanded space.

JUST MAKE SURE YOUR NEW DRIVES ARE ENTERPRISE RAID DRIVES! What are
they? WD Reds? Seagate NAS? If they don't support SCT/ERC or whatever
it's called, then your array will be a time bomb!

> thank you very much
> Math

Cheers,
Wol

