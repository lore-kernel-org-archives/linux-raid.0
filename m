From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] md: raid1,10: Handle REQ_WRITE_SAME flag in write bios
Date: Fri, 14 Dec 2012 17:38:54 -0500
Message-ID: <yq1wqwkcl8h.fsf@sermon.lab.mkp.net>
References: <alpine.DEB.2.02.1212141406480.30895@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1212141406480.30895@jlaw-desktop.mno.stratus.com>
	(Joe Lawrence's message of "Fri, 14 Dec 2012 14:36:25 -0500 (EST)")
Sender: linux-raid-owner@vger.kernel.org
To: Joe Lawrence <Joe.Lawrence@stratus.com>
Cc: linux-raid@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, neilb@suse.de
List-Id: linux-raid.ids

>>>>> "Joe" == Joe Lawrence <Joe.Lawrence@stratus.com> writes:

Joe> This sets the max_write_same_sectors for the mdev request queue to
Joe> its chunk_sectors (before merging its member disk limits).  

Yep, that's the right approach.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
