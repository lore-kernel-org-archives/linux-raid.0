From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] mdadm: add man page for --add-journal
Date: Fri, 12 Aug 2016 10:58:27 -0400
Message-ID: <wrfjshua825o.fsf@redhat.com>
References: <1470960604-2852450-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1470960604-2852450-1-git-send-email-songliubraving@fb.com> (Song
	Liu's message of "Thu, 11 Aug 2016 17:10:04 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, yizhan@redhat.com, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

Song Liu <songliubraving@fb.com> writes:
> Add the following to man page:
>
> --add-journal
>       Recreate journal for RAID-4/5/6 array that losts journal
>       devices. In current implementation, this command cannot
>       add journal to an array that had failed journal.  To
>       avoid  interrupting  on-going  write  opertions,
>       --add-journal only works for array in Read-Only state.
>
> Reported-by: Yi Zhang <yizhan@redhat.com>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  mdadm.8.in | 8 ++++++++
>  1 file changed, 8 insertions(+)

Applied, with a few minor mods.

I changed it to say this, I hope you are fine with that:

"Recreate journal for RAID-4/5/6 array that lost a journal device. In the
current implementation, this command cannot add a journal to an array
that had a failed journal. To avoid interrupting on-going write
opertions, "

If I botched it up please let me know.

Jes


>
> diff --git a/mdadm.8.in b/mdadm.8.in
> index 1a04bd1..a335c53 100644
> --- a/mdadm.8.in
> +++ b/mdadm.8.in
> @@ -1444,6 +1444,14 @@ number. The receiving node must acknowledge this message
>  with \-\-cluster\-confirm. Valid arguments are <slot>:<devicename> in case
>  the device is found or <slot>:missing in case the device is not found.
>  
> +.TP
> +.BR \-\-add-journal
> +Recreate journal for RAID-4/5/6 array that losts journal devices. In current
> +implementation, this command cannot add journal to an array that had failed
> +journal. To avoid interrupting on-going write opertions,
> +.B \-\-add-journal
> +only works for array in Read-Only state.
> +
>  .P
>  Each of these options requires that the first device listed is the array
>  to be acted upon, and the remainder are component devices to be added,
