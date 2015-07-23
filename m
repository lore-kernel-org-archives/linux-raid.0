From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] raid0: data corruption when using trim
Date: Thu, 23 Jul 2015 18:17:18 -0400
Message-ID: <yq1lhe6zfgx.fsf@sermon.lab.mkp.net>
References: <013e01d0c1d2$f3af4fb0$db0def10$@samsung.com>
	<yq1y4ibknz4.fsf@sermon.lab.mkp.net> <20150720173830.GA3274@lazy.lzy>
	<yq1a8uq3cu5.fsf@sermon.lab.mkp.net> <20150720183402.GA4439@lazy.lzy>
	<yq11tg22kyz.fsf@sermon.lab.mkp.net> <55B11A68.4080706@assyoma.it>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55B11A68.4080706@assyoma.it> (Gionatan Danti's message of "Thu,
	23 Jul 2015 18:46:32 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Gionatan Danti <g.danti@assyoma.it>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Seunguk Shin <seunguk.shin@samsung.com>, neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Gionatan" == Gionatan Danti <g.danti@assyoma.it> writes:

Gionatan> I *think* that, as this TRIM command is processed way above
Gionatan> the ATA layer (it is processed inside the device-mapper code),
Gionatan> the bug should not happen here. Is it correct? Are we safe
Gionatan> with ThinLVM + MDRAID10 + HDDs?

The problem only occurs if you are using MD linear/raid0/raid10 on top
of a device that implements either DSM TRIM (SATA) or UNMAP (SCSI). If
the device prefers WRITE SAME w/ UNMAP or if it does not support
discards at all there is no problem.

-- 
Martin K. Petersen	Oracle Linux Engineering
