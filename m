From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] md/r5cache: fix set_syndrome_sources()
Date: Mon, 13 Mar 2017 13:58:09 -0700
Message-ID: <CAPcyv4h6XBdDRrq5+cs9v70v93sHnkTUoFrKuN_-Ox_wjJvvkw@mail.gmail.com>
References: <20170313204435.1732089-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170313204435.1732089-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>, NeilBrown <neilb@suse.com>, Kernel Team <kernel-team@fb.com>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-raid.ids

On Mon, Mar 13, 2017 at 1:44 PM, Song Liu <songliubraving@fb.com> wrote:
> With srctype == SYNDROME_SRC_WRITTEN, we need include both
> dev with non-null ->written and dev with R5_InJournal.
>

Can you say a bit more about what this fixes? How does this bug
manifest itself (user visible effect), and should this be marked for
-stable?
