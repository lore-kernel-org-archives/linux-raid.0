From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] raid0: data corruption when using trim
Date: Mon, 20 Jul 2015 14:26:10 -0400
Message-ID: <yq1a8uq3cu5.fsf@sermon.lab.mkp.net>
References: <013e01d0c1d2$f3af4fb0$db0def10$@samsung.com>
	<yq1y4ibknz4.fsf@sermon.lab.mkp.net> <20150720173830.GA3274@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150720173830.GA3274@lazy.lzy> (Piergiorgio Sartor's message of
	"Mon, 20 Jul 2015 19:38:30 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Seunguk Shin <seunguk.shin@samsung.com>, neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Piergiorgio" == Piergiorgio Sartor <piergiorgio.sartor@nexgo.de> writes:

Piergiorgio> Does this mean we should disable any trimming on RAID-10
Piergiorgio> until further notice?

If you are using SATA SSDs, absolutely.

This bug has been around for a long time and I'm surprised we haven't
heard of it until now. But it's very specific to the way linear, raid0
and raid10 interface with the block layer. I'm guessing that most SSD
users deploy raid1 which is not affected.

The problem is also there if you have a storage array that prefers the
UNMAP command. But it's even less likely that you'd be using software
RAID in that case.

-- 
Martin K. Petersen	Oracle Linux Engineering
