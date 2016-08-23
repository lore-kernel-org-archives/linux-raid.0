From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 1/2] r5cache: set MD_JOURNAL_CLEAN correctly
Date: Mon, 22 Aug 2016 22:10:19 -0700
Message-ID: <20160823051019.GA2314@kernel.org>
References: <1471646042-2366825-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1471646042-2366825-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, shli@fb.com
List-Id: linux-raid.ids

On Fri, Aug 19, 2016 at 03:34:01PM -0700, Song Liu wrote:
> Currently, the code sets MD_JOURNAL_CLEAN when the array has
> MD_FEATURE_JOURNAL and the recovery_cp is MaxSector. The array
> will be MD_JOURNAL_CLEAN even if the journal device is missing.
> 
> With this patch, the MD_JOURNAL_CLEAN is only set when the journal
> device presents.

Applied this one, thanks!
