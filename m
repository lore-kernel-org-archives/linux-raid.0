From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH 1/3] md/isrt: base infrastructure and metadata loading
Date: Thu, 24 Apr 2014 00:38:01 -0700
Message-ID: <CAA9_cmcfGvBVTbxbBKBsgsnkyAux_VyKcM3V6v+tY5quQTotkQ@mail.gmail.com>
References: <20140424061756.3187.2633.stgit@viggo.jf.intel.com>
	<20140424061849.3187.48229.stgit@viggo.jf.intel.com>
	<20140424172450.7ec9452b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140424172450.7ec9452b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, jes.sorensen@redhat.com, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, Dave Jiang <dave.jiang@intel.com>
List-Id: linux-raid.ids

On Thu, Apr 24, 2014 at 12:24 AM, NeilBrown <neilb@suse.de> wrote:
> On Wed, 23 Apr 2014 23:18:49 -0700 Dan Williams <dan.j.williams@intel.com>
> wrote:
>
>> Initial md / block boilerplate for the Intel (R) Smart Response
>> Technology compatibility driver.  Supports reading the packed  metadata
>> and parsing it into a cache lookup tree.
>>
>> Cc: Dave Jiang <dave.jiang@intel.com>
>> Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> It would really help in reviewing this to have a glossary.
>
> There are frames and segments and sectors and pages.
>
> I hope sectors are 512 bytes and pages are PAGE_SIZE, which may or may not be
> 4096.
>
> And there are 16 sectors per frame, so I guess space is allocated in the
> cache in 8K aligned frames ??
>
> There are 64 segments per page so if pages did happen to be 4096 bytes, that
> makes 64 bytes per segment.  What are they?
>
> There is a list somewhere of 32byte frame descriptors which is read into a
> single vmalloced region (why? you keep page pointers, so why not read it into
> separate pages?)
> How is this organised?  I might be able to work that out from the code, but
> I'd rather not.
>
> Please don't make me guess, I'm not good at it.
>
> I guess it didn't help that diff out the header after the code.  I got bored
> before I got there and didn't read all to words, so maybe some answers are in
> there.  They don't really stand out though.

No, they don't.  Let me throw together a proper cheat sheet.

> You've chosen '8' for the 'level' number.

Hmm, ok.  I use -12 in the mdadm bits, I neglected to go back and fix
up the kernel.

> As this is an array which doesn't have redundancy, I'd rather a number <= 0.
> I think there are places where I assume >=1 has redundancy and understands
> spares etc.
>
> Should conf->count be a kref??? Just a thought, not a requirement.

Doesn't kref == 0 imply object destroyed?  It's a count of pending
metadata events.
