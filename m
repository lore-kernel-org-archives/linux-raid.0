Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A31ACDB482
	for <linux-raid@archiver.kernel.org>; Mon, 16 Oct 2023 08:51:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232955AbjJPIvH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 16 Oct 2023 04:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232971AbjJPIvG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 16 Oct 2023 04:51:06 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B861E1
        for <linux-raid@vger.kernel.org>; Mon, 16 Oct 2023 01:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697446265; x=1728982265;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8soJpnhPtOqTJkHQ1NDmGcOZx5uWiALXTo4A2ChVA/k=;
  b=cF4vrKHUwxDW1NpfGC6pbHk7tQ553Tcyp/Mvptna43hAgbYFzhQVxoQ2
   uGuRpcQo35bJPGq9ZDO0LuyQA994BRGk3poOcNo7IvzYgVx1+oDrXbmda
   dDCGYWRJAThlUNOjld2xjWXU4ebE86GdhbDta1F1tzrJWNVkCrRGM3F1o
   OGL5DErrlnaruXDsYCPd3BmGZrW0jj7ScLTSVYC5H/Qd2weNNbVrzNvwJ
   RT51iynkTVUXr9G2t+5TcELnLwFNYJ1LGZah7WEndfiSAQk1RmIK8G7Ta
   DDFcVtc8t58WNIpzkj44104iadaL7mt1cl3VcptCqAcjAw8Fjx54UX+3J
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10863"; a="471708652"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="471708652"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 01:51:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10863"; a="879363965"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="879363965"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.158.4])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 01:51:02 -0700
Date:   Mon, 16 Oct 2023 10:50:57 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Xiao Ni <xni@redhat.com>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org, colyli@suse.de,
        neilb@suse.de
Subject: Re: [PATCH 1/1] mdadm/super1: Add MD_FEATURE_RAID0_LAYOUT if
 sb->layout is set
Message-ID: <20231016105057.00007f2e@linux.intel.com>
In-Reply-To: <CALTww288hm71bTWSbpvXFH2dBeOT3nyRws_NCSUtumP+-+MYVw@mail.gmail.com>
References: <20231011130522.78994-1-xni@redhat.com>
        <20231013113034.0000298a@linux.intel.com>
        <CALTww282t6UMePRPPmoxyxBpedbjWC=9ojjHQx8o8sJttnzvSA@mail.gmail.com>
        <20231013135935.00005679@linux.intel.com>
        <CALTww288hm71bTWSbpvXFH2dBeOT3nyRws_NCSUtumP+-+MYVw@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, 16 Oct 2023 16:13:16 +0800
Xiao Ni <xni@redhat.com> wrote:

> On Fri, Oct 13, 2023 at 7:59=E2=80=AFPM Mariusz Tkaczyk
> <mariusz.tkaczyk@linux.intel.com> wrote:
> >
> > On Fri, 13 Oct 2023 18:59:21 +0800
> > Xiao Ni <xni@redhat.com> wrote:
> > =20
> > > On Fri, Oct 13, 2023 at 5:31=E2=80=AFPM Mariusz Tkaczyk
> > > <mariusz.tkaczyk@linux.intel.com> wrote: =20
> > > >
> > > > On Wed, 11 Oct 2023 21:05:22 +0800
> > > > Xiao Ni <xni@redhat.com> wrote:
> > > > =20
> > > > > In kernel space super_1_validate sets mddev->layout to -1 if
> > > > > MD_FEATURE_RAID0_LAYOUT is not set. MD_FEATURE_RAID0_LAYOUT is se=
t in
> > > > > mdadm write_init_super1. Now only raid with more than one zone ca=
n set
> > > > > this bit. But for raid0 with same size member disks, it doesn't s=
et
> > > > > this bit. The layout is *unknown* when running mdadm -D command. =
In
> > > > > fact it should be RAID0_ORIG_LAYOUT which gets from default_layou=
t.
> > > > >
> > > > > So set MD_FEATURE_RAID0_LAYOUT when sb->layout has value.
> > > > >
> > > > > Fixes: 329dfc28debb ('Create: add support for RAID0 layouts.')
> > > > > Signed-off-by: Xiao Ni <xni@redhat.com>
> > > > > ---
> > > > >  super1.c | 21 ++-------------------
> > > > >  1 file changed, 2 insertions(+), 19 deletions(-)
> > > > >
> > > > > diff --git a/super1.c b/super1.c
> > > > > index 856b02082662..f29751b4a5c7 100644
> > > > > --- a/super1.c
> > > > > +++ b/super1.c
> > > > > @@ -1978,26 +1978,10 @@ static int write_init_super1(struct super=
type
> > > > > *st) unsigned long long sb_offset;
> > > > >       unsigned long long data_offset;
> > > > >       long bm_offset;
> > > > > -     int raid0_need_layout =3D 0;
> > > > >
> > > > > -     for (di =3D st->info; di; di =3D di->next) {
> > > > > +     for (di =3D st->info; di; di =3D di->next)
> > > > >               if (di->disk.state & (1 << MD_DISK_JOURNAL))
> > > > >                       sb->feature_map |=3D
> > > > > __cpu_to_le32(MD_FEATURE_JOURNAL);
> > > > > -             if (sb->level =3D=3D 0 && sb->layout !=3D 0) {
> > > > > -                     struct devinfo *di2 =3D st->info;
> > > > > -                     unsigned long long s1, s2;
> > > > > -                     s1 =3D di->dev_size;
> > > > > -                     if (di->data_offset !=3D INVALID_SECTORS)
> > > > > -                             s1 -=3D di->data_offset;
> > > > > -                     s1 /=3D __le32_to_cpu(sb->chunksize);
> > > > > -                     s2 =3D di2->dev_size;
> > > > > -                     if (di2->data_offset !=3D INVALID_SECTORS)
> > > > > -                             s2 -=3D di2->data_offset;
> > > > > -                     s2 /=3D __le32_to_cpu(sb->chunksize);
> > > > > -                     if (s1 !=3D s2)
> > > > > -                             raid0_need_layout =3D 1;
> > > > > -             }
> > > > > -     }
> > > > >
> > > > >       for (di =3D st->info; di; di =3D di->next) {
> > > > >               if (di->disk.state & (1 << MD_DISK_FAULTY))
> > > > > @@ -2139,8 +2123,7 @@ static int write_init_super1(struct superty=
pe
> > > > > *st) sb->bblog_offset =3D 0;
> > > > >               }
> > > > >
> > > > > -             /* RAID0 needs a layout if devices aren't all the s=
ame
> > > > > size */
> > > > > -             if (raid0_need_layout)
> > > > > +             if (sb->level =3D=3D 0 && sb->layout)
> > > > >                       sb->feature_map |=3D
> > > > > __cpu_to_le32(MD_FEATURE_RAID0_LAYOUT);
> > > > >               sb->sb_csum =3D calc_sb_1_csum(sb); =20
> > > > Hi Xiao,
> > > >
> > > > I read Neil patch:
> > > > https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=3D3=
29dfc28de
> > > >
> > > > For sure Neil has a purpose to make it this way. I think that becau=
se it
> > > > breaks creation when layout is not supported by kernel. Neil wanted=
 to
> > > > keep possible largest compatibility so it sets layout feature only =
if
> > > > it is necessary. Your change forces layout bit to be always used. C=
an
> > > > you test this change on kernel without raid0_layout support? I expe=
ct
> > > > regression for same dev size raid arrays. =20
> > >
> > > Hi Mariusz
> > >
> > > Thanks for pointing out this. I only think the kernel which supports
> > > MD_FEATURE_RAID0_LAYOUT
> > > =20
> > > >
> > > > I think that before we will set layout bit we should check kernel
> > > > version, it must be higher than 5.4. In the future we would remove =
this
> > > > check. =20
>=20
> Hi Mariusz
>=20
> I just noticed the kernel version should be 3.14 rather than 5.4. In
> kernel 3.14 (20d0189b1012 block: Introduce new bio_split()) introduces
> this problem. So 5.4 is a typo error?
>=20
> Regards
> Xiao
>=20
Hi Xiao,
5.4 is a kernel where Neil introduced RAID0_LAYOUT_SUPPORT:
"Since Linux 5.4 a layout is needed for RAID0 arrays with
varying device sizes."

3.14 is a kernel when regression came but it seems that we fixed it in
5.4. I think that we can set it safely starting from 5.4.

Thanks,
Mariusz
