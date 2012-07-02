From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 2/3 v3] raid1: read balance chooses idlest disk for SSD
Date: Mon, 2 Jul 2012 11:02:45 +0800
Message-ID: <20120702030245.GB29770@kernel.org>
References: <20120702010840.197370335@kernel.org>
 <20120702011031.890864816@kernel.org>
 <CABYL=TpD7D0ec40fz6uo4LCPAKuxtkx5rD3JXfWTtuEYp3NLYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CABYL=TpD7D0ec40fz6uo4LCPAKuxtkx5rD3JXfWTtuEYp3NLYQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: linux-raid@vger.kernel.org, neilb@suse.de, axboe@kernel.dk
List-Id: linux-raid.ids

On Sun, Jul 01, 2012 at 11:13:42PM -0300, Roberto Spadim wrote:
> nice =) very very nice =)
> maybe to get better than this... select the disk with min(pending time)
> 
> time could be estimated with something like:
> (distance * time/distance unit) + (blocks to read/write * time to
> read/write 1 block) + (non sequencial penalty time)

I didn't think there is way to measure request time. Disks support NCQ, they
can dispatch several requests at one time and finish them almost at the same
time. I used to measure this time (to make CFQ ioscheduler self tune), but
failed.

Thanks,
Shaohua
