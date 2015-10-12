From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] md: fix 32-bit build warning
Date: Mon, 12 Oct 2015 11:30:11 +0200
Message-ID: <11281560.gJ28rX782P@wuerfel>
References: <5304496.D8N6u074t0@wuerfel>
 <87fv1g1y34.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <87fv1g1y34.fsf@notabene.neil.brown.name>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Neil Brown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-raid.ids

On Monday 12 October 2015 15:59:27 Neil Brown wrote:
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 7fff1e6884d6..e13f72a3b561 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -8987,9 +8987,9 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
> >  
> >       /* recovery_cp changed */
> >       if (le64_to_cpu(sb->resync_offset) != mddev->recovery_cp) {
> > -             pr_info("%s:%d recovery_cp changed from %lu to %lu\n", __func__,
> > -                             __LINE__, mddev->recovery_cp,
> > -                             (unsigned long) le64_to_cpu(sb->resync_offset));
> > +             pr_info("%s:%d recovery_cp changed from %llu to %llu\n", __func__,
> > +                             __LINE__, (u64)mddev->recovery_cp,
> > +                             (u64) le64_to_cpu(sb->resync_offset));
> >               mddev->recovery_cp = le64_to_cpu(sb->resync_offset);
> >       }
> >  
> 
> Thanks, but is this really right?
> I think u64 is "unsigned long" on 64bit.
> I have always used (unsigned long long) when I want to use %llu on
> sector_t.
> 
> How confident are you of using "u64" ?

Very confident ;-)

This used to not work until some linux-2.6 version when we changed all
architectures to use asm-generic/int-ll64.h in the kernel, because
a lot of code relied on printing u64 variables using %lld.

I tend to use u64 for things like this because it's shorter than
'unsigned long long'.

	Arnd
