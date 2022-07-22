Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BBC4C433EF
	for <linux-raid@archiver.kernel.org>; Fri, 22 Jul 2022 06:56:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbiGVG4D (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 22 Jul 2022 02:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiGVG4C (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 22 Jul 2022 02:56:02 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6145D26556
        for <linux-raid@vger.kernel.org>; Thu, 21 Jul 2022 23:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658472961; x=1690008961;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lU4XaiOlg8MJDowt1e3YcKBIByoCuT2FC4Os5GJjFxc=;
  b=eSVTnMowqqNbISKc+234HpNFMwfMsKMTY+nnIx/unSAWlo+6KMlSTHaG
   tqJsUdLBwqH8OdG4ft3RZwVXv67/jJt4T+Nfa2woYgBo+pSlz0YBnl0d8
   9mMPe7f8azGtKajCdjIuRUefDKW1/eHW17TEM3PpnNdVa3/RT69idiuKh
   hJl039W/YeUfJr9cPwt4XXcChV7T99yxmhldsEN5hvyKCv4cv4XPhJczl
   ANYXJ9YWrmyeVAyAxW+3e8cXEelncBbMiSxKEEoqIUqL1POYsz8N890Pq
   LV0i2Fq6Lknn8+2+XOs6jKg5BAaNl1PdMHRIomi8YPRE5RHskB0M2qgfC
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10415"; a="288422306"
X-IronPort-AV: E=Sophos;i="5.93,184,1654585200"; 
   d="scan'208";a="288422306"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 23:56:00 -0700
X-IronPort-AV: E=Sophos;i="5.93,184,1654585200"; 
   d="scan'208";a="626449349"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.56.115])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 23:55:59 -0700
Date:   Fri, 22 Jul 2022 08:55:54 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Neil Brown <neilb@suse.de>, Jes Sorensen <jes@trained-monkey.org>,
        linux-raid@vger.kernel.org
Subject: Re: Ternary Operator (was: [PATCH mdadm v2] super1: report
 truncated device)
Message-ID: <20220722085554.00007701@linux.intel.com>
In-Reply-To: <4cea4ea7-7d59-da76-6518-ef12ec51c09e@molgen.mpg.de>
References: <165758762945.25184.10396277655117806996@noble.neil.brown.name>
        <cff69e79-d681-c9d6-c719-8b10999a558a@molgen.mpg.de>
        <165768409124.25184.3270769367375387242@noble.neil.brown.name>
        <20220721101907.00002fee@linux.intel.com>
        <4cea4ea7-7d59-da76-6518-ef12ec51c09e@molgen.mpg.de>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 21 Jul 2022 18:21:46 +0200
Paul Menzel <pmenzel@molgen.mpg.de> wrote:

> Dear Mariusz,
>=20
>=20
> Am 21.07.22 um 10:19 schrieb Mariusz Tkaczyk:
>=20
> > On Wed, 13 Jul 2022 13:48:11 +1000 NeilBrown wrote: =20
>=20
> [=E2=80=A6]
>=20
> >> +	}
> >> +	printf("          State : %s%s\n",
> >> +	       (__le64_to_cpu(sb->resync_offset)+1)? "active":"clean",
> >> +	       info.space_after > INT64_MAX ? " TRUNCATED DEVICE" : ""); =20
> >=20
> > Could you use standard if instruction to make the code more readable? W=
e are
> > avoiding ternary operators if possible now. =20
>=20
> That=E2=80=99s news to me. Where is that documented? If find the operator=
 quite=20
> useful in situations like this.
>=20
>=20
Hi Paul,
It was Jes's preference, however I don't remember exactly when and where he
pointed that (and I cannot find it now).

To clarify - I meant inline\ternary if only.

Jes, could you look?

As you said, in this case ternary is useful, so I give it to Neil to decide
if it can be easily replaced. If not- I'm fine with current approach.

Thanks,
Mariusz
