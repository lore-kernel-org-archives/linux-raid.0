From: Stanislav Samsonov <slava@annapurnalabs.com>
Subject: Re: raid5 async_xor: sleep in atomic
Date: Mon, 28 Dec 2015 10:43:32 +0200
Message-ID: <CAFskJNg9_gJ3HRMqD4N6FSue2R2W3CSz+1KwiZw1Bp6==dOp5A@mail.gmail.com>
References: <CAFskJNhmU-N5_odOZV54x10Ku=7SSDnaMz5EtCbKddye+AGReg@mail.gmail.com>
 <87twn928qv.fsf@notabene.neil.brown.name> <CAPcyv4im63odabZ_gMF_ESuv=iZ7fyBYqLzXJDPe4cBRwtdG4g@mail.gmail.com>
 <87d1tw23jk.fsf@notabene.neil.brown.name> <CAPcyv4g=HBHn3f75gW9JKNdjYEnjxNCYEp3vjJBa_fGm7e+hJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4g=HBHn3f75gW9JKNdjYEnjxNCYEp3vjJBa_fGm7e+hJw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: NeilBrown <neilb@suse.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 24 December 2015 at 00:46, Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Wed, Dec 23, 2015 at 2:39 PM, NeilBrown <neilb@suse.com> wrote:
> > On Thu, Dec 24 2015, Dan Williams wrote:
> >>> Changing the GFP_NOIO to GFP_ATOMIC in all the calls to
> >>> dmaengine_get_unmap_data() in crypto/async_tx/ would probably fix the
> >>> issue... or make it crash even worse :-)
> >>>
> >>> Dan: do you have any wisdom here?  The xor is using the percpu data in
> >>> raid5, so it cannot be sleep, but GFP_NOIO allows sleep.
> >>> Does the code handle failure to get_unmap_data() safely?  It looks like
> >>> it probably does.
> >>
> >> Those GFP_NOIO should move to GFP_NOWAIT.  We don't want GFP_ATOMIC
> >> allocations to consume emergency reserves for a performance
> >> optimization.  Longer term async_tx needs to be merged into md
> >> directly as we can allocate this unmap data statically per-stripe
> >> rather than per request. This asyntc_tx re-write has been on the todo
> >> list for years, but never seems to make it to the top.
> >
> > So the following maybe?
> > If I could get an acked-by from you Dan, and a Tested-by: from you
> > Slava, I'll submit upstream.
> >
> > Thanks,
> > NeilBrown
> >
> > From: NeilBrown <neilb@suse.com>
> > Date: Thu, 24 Dec 2015 09:35:18 +1100
> > Subject: [PATCH] async_tx: use GFP_NOWAIT rather than GFP_IO
> >
> > These async_XX functions are called from md/raid5 in an atomic
> > section, between get_cpu() and put_cpu(), so they must not sleep.
> > So use GFP_NOWAIT rather than GFP_IO.
> >
> > Dan Williams writes: Longer term async_tx needs to be merged into md
> > directly as we can allocate this unmap data statically per-stripe
> > rather than per request.
> >
> > Reported-by: Stanislav Samsonov <slava@annapurnalabs.com>
> > Signed-off-by: NeilBrown <neilb@suse.com>
>
> Acked-by: Dan Williams <dan.j.williams@intel.com>

Tested-by: Slava Samsonov <slava@annapurnalabs.com>
