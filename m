From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: Re: [PATCH] Grow: set component size prior to array size
Date: Tue, 6 Jun 2017 16:47:32 +0200
Message-ID: <20170606144732.GA1070@proton.igk.intel.com>
References: <7964b1f5-5092-238b-403e-ed4fba584746@gmail.com>
 <1496671784-1612-1-git-send-email-tomasz.majchrzak@intel.com>
 <611d0b8e-f42f-48de-c881-bd55339d434c@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <611d0b8e-f42f-48de-c881-bd55339d434c@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jun 05, 2017 at 11:06:48AM -0400, Jes Sorensen wrote:
> On 06/05/2017 10:09 AM, Tomasz Majchrzak wrote:
> >It is a partial revert of commit 758b327cf5a7 ("Grow: Remove unnecessary
> >optimization"). For native metadata component size is set in kernel for
> >entire disk space. As external metadata supports multiple arrays within
> >one disk, the component size is set to array size. If component size is
> >not updated prior to array size update, the grow operation fails.
> >
> >Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> >---
> >  Grow.c | 2 ++
> >  1 file changed, 2 insertions(+)
> 
> Applied!
> 
> Thanks,
> Jes
>

Would you mind pushing it to the repository? I'd like to have it ported into
certain Linux distribution.

Tomek
