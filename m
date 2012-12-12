From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: MD Raid1, ext4 and write same
Date: Wed, 12 Dec 2012 13:15:49 -0500
Message-ID: <yq1txrrf86i.fsf@sermon.lab.mkp.net>
References: <alpine.DEB.2.02.1212101704450.30895@jlaw-desktop.mno.stratus.com>
	<alpine.DEB.2.02.1212121250340.30895@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1212121250340.30895@jlaw-desktop.mno.stratus.com>
	(Joe Lawrence's message of "Wed, 12 Dec 2012 12:54:53 -0500 (EST)")
Sender: linux-raid-owner@vger.kernel.org
To: Joe Lawrence <Joe.Lawrence@stratus.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de, martin.petersen@oracle.com
List-Id: linux-raid.ids

>>>>> "Joe" == Joe Lawrence <Joe.Lawrence@stratus.com> writes:

Joe> I can confirm the same issue with 3.7.0.  If anyone else is running
Joe> with raid1 and disks that support write same, can you give this a
Joe> try?

Your patch looks good to me (the do_same one). We'll need raid10.c and
raid5.c to be fixed up in a similar fashion.

-- 
Martin K. Petersen	Oracle Linux Engineering
