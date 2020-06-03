From: Song Liu <song@kernel.org>
Subject: Re: Assemblin journaled array fails
Date: Wed, 3 Jun 2020 15:07:28 -0700
Message-ID: <CAPhsuW51u6KWLvUntMXPU7stu7oSA+d-yT6zf7G0zCETzLWwiA@mail.gmail.com>
References: <f8c61278-1758-66cd-cf25-8a118cb12f58@yandex.pl>
 <CAPhsuW4WcqkDXOhcuG33bZtSEZ-V-KYPLm87piBH24eYEB0qVw@mail.gmail.com>
 <b9b6b007-2177-a844-4d80-480393f30476@yandex.pl> <CAPhsuW70NNozBmt1-zsM_Pk-39cLzi8bC3ZZaNwQ0-VgYsmkiA@mail.gmail.com>
 <f9b54d87-5b81-1fa3-04d5-ea86a6c062cb@yandex.pl> <CAPhsuW5ZfmCowTHNum5CSeadHqqPa5049weK6bq=m+JmnDE9Vg@mail.gmail.com>
 <d0340d7b-6b3a-4fd3-e446-5f0967132ef6@yandex.pl> <CAPhsuW4byXUvseqoj3Pw4r5nRGu=fHekdDec8FG6vj3of1wCyg@mail.gmail.com>
 <1cb6c63f-a74c-a6f4-6875-455780f53fa1@yandex.pl> <CAPhsuW6HdatOPJykqYCQs_7onWL1-AQRo05TygkXdRVSwAy_gQ@mail.gmail.com>
 <7b2b2bca-c1b7-06c5-10c5-2b1cdda21607@yandex.pl> <48e4fa28-4d20-ba80-cd69-b17da719531a@yandex.pl>
 <CAPhsuW69VYgLBZboxvQ6-Fmm-Oa0fGOVBg3SOVkzP_UopH+_wg@mail.gmail.com>
 <1767d7aa-6c60-7efb-bf37-6506f9aaa8a2@yandex.pl> <CAPhsuW4oMKuCrHUU1ucsMKQbSfBQdsNEQWHA1SSbGR5nbvy21w@mail.gmail.com>
 <CAPhsuW4WBDGGLYc=f4xoThxtxuF5K74m3odJ-uA98DuPLJR4nw@mail.gmail.com> <0cf6454d-a8b5-4bee-5389-94b23c077050@yandex.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0cf6454d-a8b5-4bee-5389-94b23c077050@yandex.pl>
Sender: linux-raid-owner@vger.kernel.org
To: Michal Soltys <msoltyspl@yandex.pl>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks for the trace.

On Wed, Jun 3, 2020 at 3:12 AM Michal Soltys <msoltyspl@yandex.pl> wrote:
>
> On 5/29/20 11:57 PM, Song Liu wrote:
> >>
> >> We can stop it. It didn't really hit any data checksum error in early phase
> >> of the recovery. So it did found a long long journal to recover.
> >
> > Could you please try the assemble again with the attached patch?
> >
> > Thanks,
> > Song
> >

[...]

> [Jun 3 07:42] r5c_recovery_flush_log processing ctx->seq 866200000
> [Jun 3 08:06] r5c_recovery_flush_log processing ctx->seq 866300000
> [Jun 3 08:24] r5c_recovery_flush_log processing ctx->seq 866400000
> [Jun 3 08:44] r5c_recovery_flush_log processing ctx->seq 866500000
> [Jun 3 08:58] r5l_recovery_log finished scanning with ctx->pos 408082848 ctx->seq 866583360
> [  +0.000003] md/raid:md124: recovering 24667 data-only stripes and 50212 data-parity stripes

We are recovering many stripes. I guess this is because we somehow missed a
metadata update before the crash.

> [  +0.037320] r5c_recovery_rewrite_data_only_stripes rewritten 1 stripes to the journal, current ctx->pos 408082864 ctx->seq 866583361
> [  +0.182558] r5c_recovery_rewrite_data_only_stripes rewritten 1001 stripes to the journal, current ctx->pos 408099592 ctx->seq 866584361
> [  +0.180980] r5c_recovery_rewrite_data_only_stripes rewritten 2001 stripes to the journal, current ctx->pos 408115904 ctx->seq 866585361
> [  +0.196148] r5c_recovery_rewrite_data_only_stripes rewritten 3001 stripes to the journal, current ctx->pos 408133600 ctx->seq 866586361
> [  +0.221433] r5c_recovery_rewrite_data_only_stripes rewritten 4001 stripes to the journal, current ctx->pos 408153680 ctx->seq 866587361
> [  +0.223732] r5c_recovery_rewrite_data_only_stripes rewritten 5001 stripes to the journal, current ctx->pos 408173152 ctx->seq 866588361
> [  +0.228663] r5c_recovery_rewrite_data_only_stripes rewritten 6001 stripes to the journal, current ctx->pos 408192808 ctx->seq 866589361
> [  +0.234246] r5c_recovery_rewrite_data_only_stripes rewritten 7001 stripes to the journal, current ctx->pos 408212760 ctx->seq 866590361
> [  +0.242665] r5c_recovery_rewrite_data_only_stripes rewritten 8001 stripes to the journal, current ctx->pos 408233176 ctx->seq 866591361
> [  +0.231829] r5c_recovery_rewrite_data_only_stripes rewritten 9001 stripes to the journal, current ctx->pos 408251696 ctx->seq 866592361
> [  +0.250124] r5c_recovery_rewrite_data_only_stripes rewritten 10001 stripes to the journal, current ctx->pos 408270968 ctx->seq 866593361
> [  +0.240402] r5c_recovery_rewrite_data_only_stripes rewritten 11001 stripes to the journal, current ctx->pos 408289976 ctx->seq 866594361
> [  +0.250681] r5c_recovery_rewrite_data_only_stripes rewritten 12001 stripes to the journal, current ctx->pos 408309784 ctx->seq 866595361
> [  +0.258173] r5c_recovery_rewrite_data_only_stripes rewritten 13001 stripes to the journal, current ctx->pos 408329888 ctx->seq 866596361
> [  +0.235759] r5c_recovery_rewrite_data_only_stripes rewritten 14001 stripes to the journal, current ctx->pos 408349112 ctx->seq 866597361
> [  +0.255747] r5c_recovery_rewrite_data_only_stripes rewritten 15001 stripes to the journal, current ctx->pos 408368984 ctx->seq 866598361
> [  +0.255252] r5c_recovery_rewrite_data_only_stripes rewritten 16001 stripes to the journal, current ctx->pos 408386768 ctx->seq 866599361
> [  +0.264333] r5c_recovery_rewrite_data_only_stripes rewritten 17001 stripes to the journal, current ctx->pos 408407072 ctx->seq 866600361
> [  +0.261822] r5c_recovery_rewrite_data_only_stripes rewritten 18001 stripes to the journal, current ctx->pos 408425840 ctx->seq 866601361
> [  +0.270390] r5c_recovery_rewrite_data_only_stripes rewritten 19001 stripes to the journal, current ctx->pos 408443976 ctx->seq 866602361
> [  +0.266591] r5c_recovery_rewrite_data_only_stripes rewritten 20001 stripes to the journal, current ctx->pos 408461384 ctx->seq 866603361
> [  +0.276480] r5c_recovery_rewrite_data_only_stripes rewritten 21001 stripes to the journal, current ctx->pos 408479568 ctx->seq 866604361
> [  +0.272757] r5c_recovery_rewrite_data_only_stripes rewritten 22001 stripes to the journal, current ctx->pos 408496600 ctx->seq 866605361
> [  +0.290148] r5c_recovery_rewrite_data_only_stripes rewritten 23001 stripes to the journal, current ctx->pos 408515472 ctx->seq 866606361
> [  +0.274369] r5c_recovery_rewrite_data_only_stripes rewritten 24001 stripes to the journal, current ctx->pos 408532112 ctx->seq 866607361
> [  +0.237468] r5c_recovery_rewrite_data_only_stripes done
> [  +0.062124] r5c_recovery_flush_data_only_stripes enter
> [  +0.063396] r5c_recovery_flush_data_only_stripes before wait_event

The hang happens at expected place.

> [Jun 3 09:02] INFO: task mdadm:2858 blocked for more than 120 seconds.
> [  +0.060545]       Tainted: G            E     5.4.19-msl-00001-gbf39596faf12 #2
> [  +0.062932] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.

Could you please try disable the timeout message with

echo 0 > /proc/sys/kernel/hung_task_timeout_secs

And during this wait (after message
"r5c_recovery_flush_data_only_stripes before wait_event"),
checks whether the raid disks (not the journal disk) are taking IOs
(using tools like iostat).

Thanks,
Song
