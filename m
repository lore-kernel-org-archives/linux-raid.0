From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 4/6] Assemble array with write journal
Date: Tue, 6 Oct 2015 13:11:46 -0700
Message-ID: <CAPcyv4j=8SS0Hfwu3AG3iQ+pCrXZMheMU1HM2L_LZXkNJY48wg@mail.gmail.com>
References: <1440804426-1461372-1-git-send-email-songliubraving@fb.com>
	<1440804426-1461372-5-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1440804426-1461372-5-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>, Neil Brown <neilb@suse.de>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-raid.ids

On Fri, Aug 28, 2015 at 4:27 PM, Song Liu <songliubraving@fb.com> wrote:
> Example output:
>
> ./mdadm --assemble /dev/md0 /dev/sd[c-f] /dev/sdb1
> mdadm: /dev/md0 has been started with 4 drives and 1 journal.
>
> mdadm checks superblock for journal devices. If the
> array appears to have a journal device, but it is not given,
> it will complain as
>
> ./mdadm --assemble /dev/md0 /dev/sd[c-f]
> mdadm: Not safe to assemble with journal device missing, consider --force.
>
> This can be overwritten with --force
>
> ./mdadm --assemble /dev/md0 /dev/sd[c-f] --force
> mdadm: Force start with missing journal device...
> mdadm: /dev/md0 has been started with 4 drives.
>
> Signed-off-by: Shaohua Li <shli@fb.com>
> Signed-off-by: Song Liu <songliubraving@fb.com>
[..]
> diff --git a/mdadm.h b/mdadm.h
> index 3cc1532..bc6680f 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -969,6 +969,9 @@ extern struct superswitch {
>         /* validate container after assemble */
>         int (*validate_container)(struct mdinfo *info);
>
> +       /* whether the array require a journal device */
> +       int (*require_journal)(struct supertype *st);
> +
>         int swapuuid; /* true if uuid is bigending rather than hostendian */
>         int external;
>         const char *name; /* canonical metadata name */

I'm wondering why is this a function pointer rather than a flag?  Is
it because "roles" are only an internal detail of v1 superblocks?
Might be time to make them a first class citizen.  Again, I would use
that generic "roles" enabling for a new rev of the SRT patches.
