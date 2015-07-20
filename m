From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: [PATCH] raid0: data corruption when using trim
Date: Mon, 20 Jul 2015 20:34:02 +0200
Message-ID: <20150720183402.GA4439@lazy.lzy>
References: <013e01d0c1d2$f3af4fb0$db0def10$@samsung.com>
 <yq1y4ibknz4.fsf@sermon.lab.mkp.net>
 <20150720173830.GA3274@lazy.lzy>
 <yq1a8uq3cu5.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1a8uq3cu5.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Seunguk Shin <seunguk.shin@samsung.com>, neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jul 20, 2015 at 02:26:10PM -0400, Martin K. Petersen wrote:
> >>>>> "Piergiorgio" == Piergiorgio Sartor <piergiorgio.sartor@nexgo.de> writes:
> 
> Piergiorgio> Does this mean we should disable any trimming on RAID-10
> Piergiorgio> until further notice?
> 
> If you are using SATA SSDs, absolutely.

There is LVM on top, I wonder if this
makes a difference.

Anyway thanks,

bye,

-- 

piergiorgio
