From: Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH] Problems with RAID 4/5/6 and kmem_cache
Date: Sat, 28 Sep 2013 09:49:56 +0300
Message-ID: <CAOJsxLGaNe_cap7fx8ZRZPWqkQhUbpA07Qhtgsg_+c5JdgV=qQ@mail.gmail.com>
References: <1379646960-12553-1-git-send-email-jbrassow@redhat.com>
	<0000014142863060-919062ff-7284-445d-b3ec-f38cc8d5a6c8-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0000014142863060-919062ff-7284-445d-b3ec-f38cc8d5a6c8-000000@email.amazonses.com>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Lameter <cl@linux.com>
Cc: Jonathan Brassow <jbrassow@redhat.com>, linux-raid@vger.kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>
List-Id: linux-raid.ids

On Sun, Sep 22, 2013 at 12:56 AM, Christoph Lameter <cl@linux.com> wrote:
> On Thu, 19 Sep 2013, Jonathan Brassow wrote:
>
>> 4) kmem_cache_create(name="foo-a")
>> - This FAILS because kmem_cache_sanity_check colides with the existing
>>   name ("foo-a") associated with the non-removed cache.
>
> That should not happen. breakage you see will result. Oh. I see the move
> to common code resulted in the SLAB checks being used for SLUB.
>
> The following patch should fix this.
>
> Subject: slab_common: Do not check for duplicate slab names
>
> SLUB can alias multiple slab kmem_create_requests to one slab cache
> to save memory and increase the cache hotness. As a result the name
> of the slab can be stale. Only check the name for duplicates if we are
> in debug mode where we do not merge multiple caches.
>
> Signed-off-by: Christoph Lameter <cl@linux.com>
>
> Index: linux/mm/slab_common.c
> ===================================================================
> --- linux.orig/mm/slab_common.c 2013-09-20 11:49:13.052208294 -0500
> +++ linux/mm/slab_common.c      2013-09-21 16:55:23.097131481 -0500
> @@ -56,6 +56,7 @@
>                         continue;
>                 }
>
> +#if !defined(CONFIG_SLUB) || !defined(CONFIG_SLUB_DEBUG_ON)
>                 /*
>                  * For simplicity, we won't check this in the list of memcg
>                  * caches. We have control over memcg naming, and if there
> @@ -69,6 +70,7 @@
>                         s = NULL;
>                         return -EINVAL;
>                 }
> +#endif
>         }
>
>         WARN_ON(strchr(name, ' '));     /* It confuses parsers */

Applied to slab/urgent, thanks!

Do we need to come up with something less #ifdeffy for v3.13?
