From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: RAID partition starting sector (... 63?)
Date: Wed, 17 Feb 2010 11:24:53 -0500
Message-ID: <yq17hqbg78q.fsf@sermon.lab.mkp.net>
References: <73e903671002170713g397742b8l109773b4c20825ce@mail.gmail.com>
	<yq1bpfnga3l.fsf@sermon.lab.mkp.net>
	<87r5ojon3j.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87r5ojon3j.fsf@frosties.localdomain> (Goswin von Brederlow's
	message of "Wed, 17 Feb 2010 17:15:12 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Goswin" == Goswin von Brederlow <goswin-v-b@web.de> writes:

Goswin> Newer windows starts the first partition at 1M, which gives good
Goswin> alignment in nearly every situation.

Correction: Windows aligns the first partition at 1MB + whatever
alignment is reported by the storage device.

Recent fdisk and parted to do the same.

-- 
Martin K. Petersen	Oracle Linux Engineering
