From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] raid0: data corruption when using trim
Date: Tue, 21 Jul 2015 00:28:04 -0400
Message-ID: <yq11tg22kyz.fsf@sermon.lab.mkp.net>
References: <013e01d0c1d2$f3af4fb0$db0def10$@samsung.com>
	<yq1y4ibknz4.fsf@sermon.lab.mkp.net> <20150720173830.GA3274@lazy.lzy>
	<yq1a8uq3cu5.fsf@sermon.lab.mkp.net> <20150720183402.GA4439@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150720183402.GA4439@lazy.lzy> (Piergiorgio Sartor's message of
	"Mon, 20 Jul 2015 20:34:02 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Seunguk Shin <seunguk.shin@samsung.com>, neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Piergiorgio" == Piergiorgio Sartor <piergiorgio.sartor@nexgo.de> writes:

Piergiorgio> There is LVM on top, I wonder if this makes a difference.

It does not.

-- 
Martin K. Petersen	Oracle Linux Engineering
