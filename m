Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711911C62B1
	for <linux-raid@vger.kernel.org>; Tue,  3 Sep 2024 07:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725348895; cv=none; b=L43IeuRrmmqwbKRoDG27EfrW/zVgV4VS+pjmB/tPBhVX9Re35Fr0mW1Iek6LwJfZCJbzyJ1HDIE0B+36wnDzUTf26t4oCeE7wfLDP+AIPVqpk7VLeqU9pyQK8xkp351JpRswAM3E9aWbR6eYlpLmu8PQ9SUmOKzHXl0KAxaleks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725348895; c=relaxed/simple;
	bh=CZXMZznS+bFr2Iqut+xUsc3gtMl85C5cYvjPD8+R6ZY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sped7UkQfn4WxGb4lMWHhgSZwr5Yrtjrj4JIWXixNrZd5LC6n8cZnSqffTLaHZhFKgxUHxzHFnbqOJ5iJBmQRePe/alykwUVjX3f3lIobJPYSVzSkyGJXVUJWqyLVvh4/JeAdfZdx7bvezH/43a2QDjluW6bizEzQTrgfVdM+iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C453CInb; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C453CInb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725348893; x=1756884893;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CZXMZznS+bFr2Iqut+xUsc3gtMl85C5cYvjPD8+R6ZY=;
  b=C453CInbET+VkZkDo8dG7/LA/wmlcTs6+qAthXYmInsKq3Tcf2gr9Eml
   Y/So8+4qJda2WR40uRbi8a71clWB+ONolHx9u9vGrfP5cDOit5FZY6h8C
   37c4qyD0jMyT30nlpkWBz6zWuIR5qkFosoe/pT1QmkicxuYEgd6rpFFHO
   RKov9u/hIyCo3xK6Kp2QOpije8D0DaATssuJpcET/R6G/xszRF0Kt/mrF
   ltQxUia7BIFar7KqA+PZ95dDdwjH4c1BaCYBUydtB6ioGSe7mRAFoJm8D
   EDI4fU176nZMFKfBhKS/TSQ9EKDhMun5AVhPt+ukHFMiXUk1gPWIZKVjZ
   w==;
X-CSE-ConnectionGUID: diC6aeVhQVSqlO7vsDep6w==
X-CSE-MsgGUID: SA3pZwBnT0OH4215HIpKMA==
X-IronPort-AV: E=McAfee;i="6700,10204,11183"; a="23794933"
X-IronPort-AV: E=Sophos;i="6.10,198,1719903600"; 
   d="scan'208";a="23794933"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 00:34:52 -0700
X-CSE-ConnectionGUID: e1kgyLWeQI6CjNLT0wtAsg==
X-CSE-MsgGUID: 5Vn8DJIuQNaQPjRQOYJZLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,198,1719903600"; 
   d="scan'208";a="88065002"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.1.223])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 00:34:51 -0700
Date: Tue, 3 Sep 2024 09:34:46 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: ncroxon@redhat.com, linux-raid@vger.kernel.org
Subject: Re: [PATCH 01/10] mdadm/Grow: Update new level when starting
 reshape
Message-ID: <20240903093446.00000a94@linux.intel.com>
In-Reply-To: <CALTww28fYqzAdmNdx9CmXWL4ozma2f1vx8oPYuDi2Ycds=S7zg@mail.gmail.com>
References: <20240828021150.63240-1-xni@redhat.com>
	<20240828021150.63240-2-xni@redhat.com>
	<20240902115013.00006343@linux.intel.com>
	<20240902121037.000066e9@linux.intel.com>
	<CALTww28fYqzAdmNdx9CmXWL4ozma2f1vx8oPYuDi2Ycds=S7zg@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 3 Sep 2024 08:34:46 +0800
Xiao Ni <xni@redhat.com> wrote:

> On Mon, Sep 2, 2024 at 6:10=E2=80=AFPM Mariusz Tkaczyk
> <mariusz.tkaczyk@linux.intel.com> wrote:
> >
> > On Mon, 2 Sep 2024 11:50:13 +0200
> > Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com> wrote:
> > =20
> > > Hi Xiao,
> > > Thanks for patches.
> > >
> > > On Wed, 28 Aug 2024 10:11:41 +0800
> > > Xiao Ni <xni@redhat.com> wrote:
> > > =20
> > > > Reshape needs to specify a backup file when it can't update data of=
fset
> > > > of member disks. For this situation, first, it starts reshape and t=
hen
> > > > it kicks off mdadm-grow-continue service which does backup job and
> > > > monitors the reshape process. The service is a new process, so it n=
eeds
> > > > to read superblock from member disks to get information. =20
> > >
> > > Looks like kernel is fine with reset the same level so I don't see a =
risk
> > > in this change for other scenarios but please mention that.
> > > =20
> >
> > Sorry, I didn't notice that it is new field. We should not update it if=
 it
> > doesn't exist. Perhaps, we should print message that kernel patch is
> > needed? =20
>=20
> We can merge this patch set after the kernel patch is merged. Because
> this change depends on the kernel change. If the kernel patch is
> rejected, we need to find another way to fix this problem.

We have to mention kernel commit in description then.


Let say that it is merged, we should probably notify user,
"hey your kernel is missing the kernel patch that allow this functionality =
to
work reliably, issue may occur". What do you think? Is it valuable?

Thanks,
Mariusz
