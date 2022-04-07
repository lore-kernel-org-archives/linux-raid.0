Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50560C433EF
	for <linux-raid@archiver.kernel.org>; Thu,  7 Apr 2022 07:10:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241425AbiDGHL5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 7 Apr 2022 03:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241441AbiDGHL4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 7 Apr 2022 03:11:56 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890CB13D33
        for <linux-raid@vger.kernel.org>; Thu,  7 Apr 2022 00:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649315397; x=1680851397;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fqSvJWl/uAT432C/ngN3GbC6cwHvtxQhn/NMFlctMq8=;
  b=ktEP2wu8xg/05D6giBKTvflE3fZtLHalI4JxyvsRTBQh4MNaG1jjxquM
   5U0Wz5AqxexpOfG8ot+dUDdNjhCxYdaik+qKPkvtTEwEyz9bisw7m/hFc
   pnh5urVYMo3tVSqaMTOhwNN3xwBMQpZofkpRnRiIwOScFHyGFasCN1hAL
   x8A8qYYpy8jUZPSP/0xXlFaUSpYkhyBt8zIlGZ6pLicZG+t1WZWoOTwqG
   n00+XWCg3Wnqml2FalunfJESI1I6C2psWycmhVVGyHEqT3bloscRGRryB
   aqhF6S2wGcDsy0KdRiD0E6A0wlzjtdDaaNgcARaecr4lMSf5uRqD17hG7
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10309"; a="261241178"
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="261241178"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 00:09:57 -0700
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="570926629"
Received: from karolcwi-mobl.ger.corp.intel.com (HELO localhost) ([10.213.29.206])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 00:09:55 -0700
Date:   Thu, 7 Apr 2022 09:09:50 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Mateusz Kusiak <mateusz.kusiak@intel.com>,
        linux-raid@vger.kernel.org, colyli@suse.de
Subject: Re: [PATCH] Add RAID 1 chunksize test
Message-ID: <20220407090950.0000501f@linux.intel.com>
In-Reply-To: <9653c1f1-1aae-3c5d-2a43-4cb3109392b0@trained-monkey.org>
References: <20220404070830.7795-1-mateusz.kusiak@intel.com>
        <53bc131b71b7f94210e507eed93390b1b3899246.camel@redhat.com>
        <9653c1f1-1aae-3c5d-2a43-4cb3109392b0@trained-monkey.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 6 Apr 2022 12:46:03 -0400
Jes Sorensen <jes@trained-monkey.org> wrote:

> On 4/4/22 08:38, Doug Ledford wrote:
> > On Mon, 2022-04-04 at 09:08 +0200, Mateusz Kusiak wrote: =20
> >> Specifying chunksize for raid 1 is forbidden.
> >> Add test for blocking raid 1 creation with chunksize.
> >>
> >> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
> >> ---
> >> =A0tests/01r1create-chunk | 15 +++++++++++++++
> >> =A01 file changed, 15 insertions(+)
> >> =A0create mode 100644 tests/01r1create-chunk
> >>
> >> diff --git a/tests/01r1create-chunk b/tests/01r1create-chunk
> >> new file mode 100644
> >> index 00000000..717a5e5a
> >> --- /dev/null
> >> +++ b/tests/01r1create-chunk
> >> @@ -0,0 +1,15 @@
> >> +# RAID 1 volume, 2 disks, chunk 64
> >> +# NEGATIVE test - creating raid 1 with chunksize specified is
> >> forbidden
> >> +
> >> +num_disks=3D2
> >> +level=3D1
> >> +device_list=3D"$dev0 $dev1"
> >> +chunk=3D64
> >> +
> >> +# Create raid 1 with chunk 64k and fail
> >> +if ! mdadm --create --run $md0 --auto=3Dmd --level=3D$level --
> >> chunk=3D$chunk --raid-disks=3D$num_disks $device_list
> >> +then
> >> +=A0=A0=A0=A0=A0=A0=A0exit 0
> >> +fi
> >> +
> >> +exit 1 =20
> >=20
> > This is a case of overkill IMO.  Chunk size with raid1 isn't really
> > a problem and shouldn't result in mdadm refusing to work.  Chunk
> > size with raid1 simply has no effect and should just be ignored
> > with at most a warning by mdadm. =20
>=20
> I agree with Doug here. I think a warning from mdadm that chunksize
> makes no sense for raid1 would be good, but having a failed test over
> it makes little sense. If anything the test should detect the warning
> is happening.
>

Ideally, chunk parameter for RAID1 should not be recognized, because it
is not an option. For that reason I'm closer to say that we shouldn't
continue if chunk is passed. It helps to limit abuses from less
experienced users.

Jes, you asked for this test:
https://lore.kernel.org/linux-raid/bdcc98ec-72bc-d0ab-7e82-7e00bc02447f@tra=
ined-monkey.org/

Thanks,
Mariusz

