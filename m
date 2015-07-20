From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: [PATCH] raid0: data corruption when using trim
Date: Mon, 20 Jul 2015 19:38:30 +0200
Message-ID: <20150720173830.GA3274@lazy.lzy>
References: <013e01d0c1d2$f3af4fb0$db0def10$@samsung.com>
 <yq1y4ibknz4.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1y4ibknz4.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Seunguk Shin <seunguk.shin@samsung.com>, neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jul 20, 2015 at 08:33:35AM -0400, Martin K. Petersen wrote:
> >>>>> "Seunguk" == Seunguk Shin <seunguk.shin@samsung.com> writes:
> 
> Seunguk,
> 
> Thanks for tracking this down. Instead of explicitly coding around the
> issue in raid0/raid10/linear I would prefer to fix bio_split(). It seems

Does this mean we should disable any trimming
on RAID-10 until further notice?

Thanks,

bye,

-- 

piergiorgio
