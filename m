From: Song Liu <song@kernel.org>
Subject: Re: Assemblin journaled array fails
Date: Tue, 23 Jun 2020 16:13:00 -0700
Message-ID: <CAPhsuW4hnpsbhQWWNKqgnw4nhp4Ho+gFbPU2fGjoMOcM8y7L+Q@mail.gmail.com>
References: <f8c61278-1758-66cd-cf25-8a118cb12f58@yandex.pl>
 <CAPhsuW4oMKuCrHUU1ucsMKQbSfBQdsNEQWHA1SSbGR5nbvy21w@mail.gmail.com>
 <CAPhsuW4WBDGGLYc=f4xoThxtxuF5K74m3odJ-uA98DuPLJR4nw@mail.gmail.com>
 <0cf6454d-a8b5-4bee-5389-94b23c077050@yandex.pl> <CAPhsuW51u6KWLvUntMXPU7stu7oSA+d-yT6zf7G0zCETzLWwiA@mail.gmail.com>
 <49efa0d2-b44c-ec85-5e44-fb93a15001e7@yandex.pl> <4df42e3d-ad2b-dfc2-3961-49ada4ea7eaf@yandex.pl>
 <CAPhsuW5kk0G9PSfEADc8+rn=QT2z4ogjuV98qWsH_s_WBic-5w@mail.gmail.com>
 <71f58507-314e-4a1d-dd50-41a60d76521b@yandex.pl> <CAPhsuW59Q7mU9WH36RHs9kb-TMk7FmrQL+JCApupf_TZtpWynA@mail.gmail.com>
 <4a03e900-61a8-f150-9be8-739e88ba8ce6@yandex.pl> <CAPhsuW4BZE-DeESsq-coNx5_KZrfHjP=d9YOjOPqPji5kQBXjg@mail.gmail.com>
 <a772ede5-1d6f-e7cd-e949-a5d81d0fdbd1@yandex.pl> <CAPhsuW5hwAMTy8ozpsT+n5F3M7NzKqBdheFZvnouZEv8hEqAxQ@mail.gmail.com>
 <4b426e56-f971-67cf-81c0-63e035bf492a@yandex.pl> <CAPhsuW6fvgRCz7X7nnCEof4+yy2fTsxShNCuqTkMC0JQpj6gKw@mail.gmail.com>
 <57247f5e-ec38-fb8c-9684-abbe699945fb@yandex.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57247f5e-ec38-fb8c-9684-abbe699945fb@yandex.pl>
Sender: linux-raid-owner@vger.kernel.org
To: Michal Soltys <msoltyspl@yandex.pl>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jun 23, 2020 at 6:17 AM Michal Soltys <msoltyspl@yandex.pl> wrote:
>
> On 6/22/20 6:37 PM, Song Liu wrote:
> >>>
> >>> Thanks for the trace. Looks like we may have some issues with
> >>> MD_SB_CHANGE_PENDING.
> >>> Could you please try the attached patch?
> >>
> >> Should I run this along with pr_debugs from the previous patch enabled ?
> >
> > We don't need those pr_debug() here.
> >
> > Thanks,
> > Song
> >
>
> So with this patch attached, there is no extra output whatsoever - once it finished getting past this point:
>
> [  +0.371752] r5c_recovery_rewrite_data_only_stripes rewritten 20001 stripes to the journal, current ctx->pos 408461384 ctx->seq 866603361
> [  +0.395000] r5c_recovery_rewrite_data_only_stripes rewritten 21001 stripes to the journal, current ctx->pos 408479568 ctx->seq 866604361
> [  +0.371255] r5c_recovery_rewrite_data_only_stripes rewritten 22001 stripes to the journal, current ctx->pos 408496600 ctx->seq 866605361
> [  +0.401013] r5c_recovery_rewrite_data_only_stripes rewritten 23001 stripes to the journal, current ctx->pos 408515472 ctx->seq 866606361
> [  +0.370543] r5c_recovery_rewrite_data_only_stripes rewritten 24001 stripes to the journal, current ctx->pos 408532112 ctx->seq 866607361
> [  +0.319253] r5c_recovery_rewrite_data_only_stripes done
> [  +0.061560] r5c_recovery_flush_data_only_stripes enter
> [  +0.075697] r5c_recovery_flush_data_only_stripes before wait_event
>
> That is, besides 'task <....> blocked for' traces or unless pr_debug()s were enabled.
>
> There were a few 'md_write_start set MD_SB_CHANGE_PENDING' *before* that (all of them likely related to another raid that is active at the moment, as these were happening during that lengthy r5c_recovery_flush_log() process).

Hmm.. this is weird, as I think I marked every instance of set_bit
MD_SB_CHANGE_PENDING.
Would you mind confirm those are to the other array with something like:

diff --git i/drivers/md/md.c w/drivers/md/md.c
index dbbc8a50e2ed2..e91acfdcec032 100644
--- i/drivers/md/md.c
+++ w/drivers/md/md.c
@@ -8480,7 +8480,7 @@ bool md_write_start(struct mddev *mddev, struct bio *bi)
                        mddev->in_sync = 0;
                        set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
                        set_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags);
-                       pr_info("%s set MD_SB_CHANGE_PENDING\n", __func__);
+                       pr_info("%s: md: %s set
MD_SB_CHANGE_PENDING\n", __func__, mdname(mddev));
                        md_wakeup_thread(mddev->thread);
                        did_change = 1;
                }

Thanks,
Song
