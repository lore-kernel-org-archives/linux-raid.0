From: William Kucharski <william.kucharski@oracle.com>
Subject: Re: [LSF/MM TOPIC] (again) THP for file systems
Date: Thu, 14 Feb 2019 03:55:50 -0700
Message-ID: <98E2D333-409A-47AF-886F-3E661BD1C4EE@oracle.com>
References: <77A00946-D70D-469D-963D-4C4EA20AE4FA@fb.com>
 <20190213235959.GX12668@bombadil.infradead.org>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.2\))
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190213235959.GX12668@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: Song Liu <songliubraving@fb.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "Kirill A. Shutemov" <kirill@shutemov.name>
List-Id: linux-raid.ids



> On Feb 13, 2019, at 4:59 PM, Matthew Wilcox <willy@infradead.org> wrote:
> 
> I believe the direction is clear.  It needs people to do the work.
> We're critically short of reviewers.  I got precious little review of
> the original XArray work, which made Andrew nervous and delayed its
> integration.  Now I'm getting little review of the followup patches
> to lay the groundwork for filesystems to support larger page sizes.
> I have very little patience for this situation.

I'll be happy to dive in and look at the changes from an mm point of view,
but I don't feel qualified to comment on all the file system
considerations.

Perhaps if someone from the fs side would volunteer; I know well how
frustrating it can be to be trapped in code review suspended animation.
