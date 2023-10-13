Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DF74CDB483
	for <linux-raid@archiver.kernel.org>; Fri, 13 Oct 2023 12:00:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbjJMMAX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 13 Oct 2023 08:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbjJML77 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 13 Oct 2023 07:59:59 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7647E0
        for <linux-raid@vger.kernel.org>; Fri, 13 Oct 2023 04:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697198383; x=1728734383;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OWhkbXHn1bKoTWDv220gHw1TPn55dhNSUaEUoCHfkKc=;
  b=OB9Rtvw55SrdOGWKahfm28KdSWjkRZiUQ07NmCCPLFJQ8JpniB2DWwPF
   EM2av1cQdM4ep/DBCi09jt+9XSP8BEidM294WBFBmyj/U30I7LQlMAysN
   VYnZexHqklU5rQRLUSGihxH6wwISqiBelGz4tscbHOMm3Hymuc0BpDSyg
   bDgfTfAQ93BJsvUu4NUmL+gf5UNimfQnKjYsDPw6Q5u/sXM1FezMOq8bG
   MXmbdluRLmueJhxzId+VTanVA+MJEW+dGiFVZWpxUHO1PJeOQYRKxqTnI
   P5DVAV8r1bk59AaDETMuYaSHIK8HAksxvCUnoRww2L4jd4TMNvpnZ9a9f
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10861"; a="389032321"
X-IronPort-AV: E=Sophos;i="6.03,222,1694761200"; 
   d="scan'208";a="389032321"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2023 04:59:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10861"; a="820597853"
X-IronPort-AV: E=Sophos;i="6.03,222,1694761200"; 
   d="scan'208";a="820597853"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.156.199])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2023 04:59:39 -0700
Date:   Fri, 13 Oct 2023 13:59:35 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Xiao Ni <xni@redhat.com>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org, colyli@suse.de,
        neilb@suse.de
Subject: Re: [PATCH 1/1] mdadm/super1: Add MD_FEATURE_RAID0_LAYOUT if
 sb->layout is set
Message-ID: <20231013135935.00005679@linux.intel.com>
In-Reply-To: <CALTww282t6UMePRPPmoxyxBpedbjWC=9ojjHQx8o8sJttnzvSA@mail.gmail.com>
References: <20231011130522.78994-1-xni@redhat.com>
        <20231013113034.0000298a@linux.intel.com>
        <CALTww282t6UMePRPPmoxyxBpedbjWC=9ojjHQx8o8sJttnzvSA@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 13 Oct 2023 18:59:21 +0800
Xiao Ni <xni@redhat.com> wrote:

> On Fri, Oct 13, 2023 at 5:31=E2=80=AFPM Mariusz Tkaczyk
> <mariusz.tkaczyk@linux.intel.com> wrote:
> >
> > On Wed, 11 Oct 2023 21:05:22 +0800
> > Xiao Ni <xni@redhat.com> wrote:
> > =20
> > > In kernel space super_1_validate sets mddev->layout to -1 if
> > > MD_FEATURE_RAID0_LAYOUT is not set. MD_FEATURE_RAID0_LAYOUT is set in
> > > mdadm write_init_super1. Now only raid with more than one zone can set
> > > this bit. But for raid0 with same size member disks, it doesn't set t=
his
> > > bit. The layout is *unknown* when running mdadm -D command. In fact it
> > > should be RAID0_ORIG_LAYOUT which gets from default_layout.
> > >
> > > So set MD_FEATURE_RAID0_LAYOUT when sb->layout has value.
> > >
> > > Fixes: 329dfc28debb ('Create: add support for RAID0 layouts.')
> > > Signed-off-by: Xiao Ni <xni@redhat.com>
> > > ---
> > >  super1.c | 21 ++-------------------
> > >  1 file changed, 2 insertions(+), 19 deletions(-)
> > >
> > > diff --git a/super1.c b/super1.c
> > > index 856b02082662..f29751b4a5c7 100644
> > > --- a/super1.c
> > > +++ b/super1.c
> > > @@ -1978,26 +1978,10 @@ static int write_init_super1(struct supertype=
 *st)
> > >       unsigned long long sb_offset;
> > >       unsigned long long data_offset;
> > >       long bm_offset;
> > > -     int raid0_need_layout =3D 0;
> > >
> > > -     for (di =3D st->info; di; di =3D di->next) {
> > > +     for (di =3D st->info; di; di =3D di->next)
> > >               if (di->disk.state & (1 << MD_DISK_JOURNAL))
> > >                       sb->feature_map |=3D
> > > __cpu_to_le32(MD_FEATURE_JOURNAL);
> > > -             if (sb->level =3D=3D 0 && sb->layout !=3D 0) {
> > > -                     struct devinfo *di2 =3D st->info;
> > > -                     unsigned long long s1, s2;
> > > -                     s1 =3D di->dev_size;
> > > -                     if (di->data_offset !=3D INVALID_SECTORS)
> > > -                             s1 -=3D di->data_offset;
> > > -                     s1 /=3D __le32_to_cpu(sb->chunksize);
> > > -                     s2 =3D di2->dev_size;
> > > -                     if (di2->data_offset !=3D INVALID_SECTORS)
> > > -                             s2 -=3D di2->data_offset;
> > > -                     s2 /=3D __le32_to_cpu(sb->chunksize);
> > > -                     if (s1 !=3D s2)
> > > -                             raid0_need_layout =3D 1;
> > > -             }
> > > -     }
> > >
> > >       for (di =3D st->info; di; di =3D di->next) {
> > >               if (di->disk.state & (1 << MD_DISK_FAULTY))
> > > @@ -2139,8 +2123,7 @@ static int write_init_super1(struct supertype *=
st)
> > >                       sb->bblog_offset =3D 0;
> > >               }
> > >
> > > -             /* RAID0 needs a layout if devices aren't all the same =
size
> > > */
> > > -             if (raid0_need_layout)
> > > +             if (sb->level =3D=3D 0 && sb->layout)
> > >                       sb->feature_map |=3D
> > > __cpu_to_le32(MD_FEATURE_RAID0_LAYOUT);
> > >               sb->sb_csum =3D calc_sb_1_csum(sb); =20
> > Hi Xiao,
> >
> > I read Neil patch:
> > https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=3D329df=
c28de
> >
> > For sure Neil has a purpose to make it this way. I think that because it
> > breaks creation when layout is not supported by kernel. Neil wanted to =
keep
> > possible largest compatibility so it sets layout feature only if it is
> > necessary. Your change forces layout bit to be always used. Can you test
> > this change on kernel without raid0_layout support? I expect regression=
 for
> > same dev size raid arrays. =20
>=20
> Hi Mariusz
>=20
> Thanks for pointing out this. I only think the kernel which supports
> MD_FEATURE_RAID0_LAYOUT
>=20
> >
> > I think that before we will set layout bit we should check kernel
> > version, it must be higher than 5.4. In the future we would remove this
> > check. =20

>=20
> Let me check if I understand right:
>=20
> It needs to check raid0_need_layout when <=3D kernel 5.4. It can set
> MD_FEATURE_RAID0_LAYOUT for all raid0 > kernel 5.4

Correct! I'm accepting risk in extraordinary cases. In general, kernel is b=
umped
not downgraded.

>=20
>=20
> > So, it forces the calculations made by Neil back but I think that we can
> > simply compare dev_size and data_offset between members. =20
>=20
> We don't need to consider the compatibility anymore in future?
>=20
Not sure if I get your question correctly. This property is supported now so
why we should? It is already there so we are safe to set it.

This comment is about code optimization here:
> > > -                     struct devinfo *di2 =3D st->info;
> > > -                     unsigned long long s1, s2;
> > > -                     s1 =3D di->dev_size;
> > > -                     if (di->data_offset !=3D INVALID_SECTORS)
> > > -                             s1 -=3D di->data_offset;
> > > -                     s1 /=3D __le32_to_cpu(sb->chunksize);
> > > -                     s2 =3D di2->dev_size;
> > > -                     if (di2->data_offset !=3D INVALID_SECTORS)
> > > -                             s2 -=3D di2->data_offset;
> > > -                     s2 /=3D __le32_to_cpu(sb->chunksize);
> > > -                     if (s1 !=3D s2)
> > > -                             raid0_need_layout =3D 1;

I think that we can check:
if (di->dev_size !=3D di2->dev_size || di->data_offset !=3D di2->data_offse=
t)
    raid0_need_layout =3D 1;

but I could be wrong here, it is zoned raid, I don't have experience in this
area. It is existing code so you don't need to dig into. You can left it as=
 is.

Isn't the size of members saved somewhere, do we need to count it?

Mariusz
