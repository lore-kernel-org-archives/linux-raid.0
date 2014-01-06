From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Why 4k native drives haven't arrived
Date: Mon, 06 Jan 2014 18:50:24 -0500
Message-ID: <yq161pwy8jj.fsf@sermon.lab.mkp.net>
References: <52C61807.6050906@hardwarefreak.com>
	<yq1d2k8zsie.fsf@sermon.lab.mkp.net>
	<21193.43286.201949.339364@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <21193.43286.201949.339364@tree.ty.sabi.co.uk> (Peter Grandi's
	message of "Sun, 5 Jan 2014 18:48:54 +0000")
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Peter" == Peter Grandi <pg@lxra2.for.sabi.co.UK> writes:

Peter> There are some obvious wins to addressing in 4KiB sectors, the
Peter> most important of which is the avoidance of RMW as a possibility.

There are also drives where you can disable RMW explicitly. I.e. the
drive appears as 512e but will reject any misaligned non-multiple of 4K.

The downside to 4Kn is that it breaks applications using direct I/O that
assume that the sector size is 512 bytes. Which essentially means all of
them. Solaris opted to do RMW in software to overcome that issue.
Whereas we are trying to get application writers to fix their code...

Peter> But there is another important short term win, as older storage
Peter> protols and formats relate maximum disk or partition or filetree
Peter> capacity to maximum number of sectors addressable, which is often
Peter> fixed at below 2^32 or 2^31, so addresses in units of 4KiB
Peter> sectors allow 8 times more capacity than 512B ones.

Yep. Although in Linux we use 512-byte sectors throughout the I/O stack
regardless of the device's logical block size.

-- 
Martin K. Petersen	Oracle Linux Engineering
