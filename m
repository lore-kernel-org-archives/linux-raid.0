From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: RAID-5 degraded mode question
Date: Mon, 21 Dec 2009 13:41:28 +0100
Message-ID: <87ljgwo5xj.fsf@frosties.localdomain>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C087E7E75@SDCEXCHANGE01.ad.amcc.com>
	<20091216211237.GA16981@cthulhu.home.robinhill.me.uk>
	<AC5E1C3367E37D44970B81A6ADD1DA2C087E7EA7@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AC5E1C3367E37D44970B81A6ADD1DA2C087E7EA7@SDCEXCHANGE01.ad.amcc.com>
	(Tirumala Reddy Marri's message of "Wed, 16 Dec 2009 13:29:21 -0800")
Sender: linux-raid-owner@vger.kernel.org
To: Tirumala Reddy Marri <tmarri@amcc.com>
Cc: Robin Hill <robin@robinhill.me.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Tirumala Reddy Marri" <tmarri@amcc.com> writes:

> Thanks for the response.
>
>>>  Also as soon as disk failed md drivers marks that drive as faulty
> and 
>>> continue operation in degraded mode right ? Is there a way to get out
>
>>> the degraded mode without adding spare drive. Assuming we have 5 disk
>
>>> system with one failed drive.
>>> 
>>I'm not sure what you want to happen here.  The only way to get out of
> degraded mode is to replace the drive in the >array (if it's not
> actually faulty then you can add it back, otherwise you need to add a
> new drive).
>>What were you thinking might happen otherwise?
>
>
> I was thinking we can recover from this using re-sync or resize .After

Theoretically you could shrink the array by one disk and then use that
spare disk to resync the parity. But that is a lengthy process with a
lot higher failure chance than resyncing to a new disk. Note that you
also need to shrink the filesystem on the raid first adding even more
stress and failure chance. So I really wouldn't recommend that.

> running IO to degraded (RAID-5) /dev/md0, I am seeing an issue where
> e2fsck reports inconsistent file system and corrects it. I am trying to
> debug  to see if the issue is because of data not being written or
> reading wrong data in degraded mode. 
>
> I guess problem happening during the write. Reason is , after ran e2fsck
> I don't see inconsistency any more.
>
> Regards,
> Marri

A degraded raid5 might get corrupted if your system crashes. If you
are writing to one of the remaining disks then it also needs to update
the parity block simultaneously. If it crashed between writing the
data and the parity then the data block on the failed drive will
appear changed. I'm not sure though if the raid will even assemble on
its own in such a case though. It might just complain about not having
enough in-sync disks.

Apart from that there should never be any corruption unless one of
your disks returns bad data on read.

MfG
        Goswin

PS: This is not a bug in linux raid but a fundamental limitation of
raid.
