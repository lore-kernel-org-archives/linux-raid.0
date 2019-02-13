From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [LSF/MM TOPIC] (again) THP for file systems
Date: Wed, 13 Feb 2019 15:59:59 -0800
Message-ID: <20190213235959.GX12668@bombadil.infradead.org>
References: <77A00946-D70D-469D-963D-4C4EA20AE4FA@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <77A00946-D70D-469D-963D-4C4EA20AE4FA@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "Kirill A. Shutemov" <kirill@shutemov.name>
List-Id: linux-raid.ids

On Wed, Feb 13, 2019 at 10:00:10PM +0000, Song Liu wrote:
> I would like to discuss remaining work to bring THP to (non-tmpfs) file systems.
> This topic has been discussed multiple times in previous LSF/MM summits [1][2].
> However, there hasn't been much progress since late 2017 (the latest work I can
> find is by Kirill A. Shutemov [3]).

... this was literally just discussed.

Feel free to review
https://lore.kernel.org/lkml/20190212183454.26062-1-willy@infradead.org/

with particular reference to the last three paragraphs of
https://lore.kernel.org/lkml/20190208042448.GB21860@bombadil.infradead.org/

> Therefore, we would like discuss (for one more time) what is needed to bring
> THP to file systems like ext4, xfs, btrfs, etc. Once we are aligned on the
> direction, we are more than happy to commit time and resource to make it happen.

I believe the direction is clear.  It needs people to do the work.
We're critically short of reviewers.  I got precious little review of
the original XArray work, which made Andrew nervous and delayed its
integration.  Now I'm getting little review of the followup patches
to lay the groundwork for filesystems to support larger page sizes.
I have very little patience for this situation.
