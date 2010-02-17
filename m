From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: RAID partition starting sector (... 63?)
Date: Wed, 17 Feb 2010 13:42:39 -0500
Message-ID: <yq1pr43emao.fsf@sermon.lab.mkp.net>
References: <73e903671002170713g397742b8l109773b4c20825ce@mail.gmail.com>
	<yq1bpfnga3l.fsf@sermon.lab.mkp.net>
	<87r5ojon3j.fsf@frosties.localdomain>
	<yq17hqbg78q.fsf@sermon.lab.mkp.net>
	<87f94c371002171013x53acb705kf0d4f194e211fb27@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c371002171013x53acb705kf0d4f194e211fb27@mail.gmail.com>
	(Greg Freemyer's message of "Wed, 17 Feb 2010 13:13:42 -0500")
Sender: linux-raid-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Goswin von Brederlow <goswin-v-b@web.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Greg" == Greg Freemyer <greg.freemyer@gmail.com> writes:

>> Recent fdisk and parted to do the same.

Greg> I assume this is through the relatively new /sysfs interface.  

Or block device ioctls, libblkid, etc.  Pick your poison.


Greg> Is mdraid now advertising its preferred stripe alignments through
Greg> /sysfs?

Yep.

-- 
Martin K. Petersen	Oracle Linux Engineering
