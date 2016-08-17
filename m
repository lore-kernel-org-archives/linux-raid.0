From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: do not count journal as spare in GET_ARRAY_INFO
Date: Tue, 16 Aug 2016 18:33:47 -0700
Message-ID: <20160817013347.GA102966@kernel.org>
References: <1470960885-2860586-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1470960885-2860586-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, yizhan@redhat.com, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

On Thu, Aug 11, 2016 at 05:14:45PM -0700, Song Liu wrote:
> GET_ARRAY_INFO counts journal as spare (spare_disks), which is not
> accurate. This patch fixes this.
> 
> Reported-by: Yi Zhang <yizhan@redhat.com>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Shaohua Li <shli@fb.com>

Applied, thanks.
