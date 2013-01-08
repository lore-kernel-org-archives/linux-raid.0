From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] md: raid1,10: Handle REQ_WRITE_SAME flag in write bios
Date: Mon, 07 Jan 2013 19:21:27 -0500
Message-ID: <yq1d2xgwmm0.fsf@sermon.lab.mkp.net>
References: <alpine.DEB.2.02.1212141406480.30895@jlaw-desktop.mno.stratus.com>
	<alpine.DEB.2.02.1301021039110.31163@jlaw-desktop.mno.stratus.com>
	<20130107132206.7d25de89@notabene.brown>
	<alpine.DEB.2.02.1301071547060.31163@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1301071547060.31163@jlaw-desktop.mno.stratus.com>
	(Joe Lawrence's message of "Mon, 7 Jan 2013 15:56:27 -0500 (EST)")
Sender: linux-raid-owner@vger.kernel.org
To: Joe Lawrence <Joe.Lawrence@stratus.com>
Cc: NeilBrown <neilb@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Joe" == Joe Lawrence <Joe.Lawrence@stratus.com> writes:

Joe> On Mon, 7 Jan 2013, NeilBrown wrote:
>> Assuming that a REQ_WRITE_SAME is just like a normal write except for
>> the iovec being shorter (is that right?)

Yes, that's correct. bio_sectors() will correspond to the area worked on
but the bio_vec just describes a single logical block.

-- 
Martin K. Petersen	Oracle Linux Engineering
