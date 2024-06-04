Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D922F81721
	for <linux-raid@vger.kernel.org>; Tue,  4 Jun 2024 16:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717519136; cv=none; b=WelgU8r41Nzed1S4/7uHgR1XoptGedpS5zJnYo/7eqB7xzvR+A0/6IQbO4zoogOebyV/bhDYXxS0d53MajQ7MjHYCnLXUgj3VlermeH2504bfZDRMSwJ3Vu5Eg1eHjEVnuNjBctcAPqd8CCnmsxoP2pY5lC4r+YTj94FTczDh3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717519136; c=relaxed/simple;
	bh=yyGRhwkw3x3P/HE5aRFXcMWTKvC6dHq0mgQMg7DzVJ0=;
	h=From:To:Cc:Date:Message-Id:MIME-Version:Subject; b=NH3ad4eQGNivGVAkM0+vsHc3LIKjoWq/YA7YG8wIYaNutJdXEnfmOrlk2GFPlRwgxob8ehv9Xqfxw6VpoQyVERhAigv91+JPHJJ0aE4eUXuaZIbkFqPFcczEC9o8kAxsTweGgJLRF2ww0jPAOrmhGyxgdGj0vsTacbjEyyuL2QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=GpcceIcU; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="GpcceIcU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:MIME-Version:Message-Id:Date:Cc:To:From
	:references:content-disposition:in-reply-to;
	bh=1KFwTjYOJuhew4MEG7RVu+UGnP2mr9IzJwCZaaAiSM4=; b=GpcceIcU9RFnUTKzTsF+ZUgCzy
	BWcCl60xNYB0amXJ+5ZDAjbFg536nurJhPvbvplhlvO09TV/cOFSQB0bh7mH94ryIeiNHJT840MOi
	r2PQK6ijwMJEKOysolCYFrtHO3DB81aBTLv08KLzTd/8h7vueHZheKssSKXHYcPgtoGn+V6YfJeXU
	FX/43bVtgxPTyg/DgmK2yLPH1iLneMk4iNOMVLsBqVf6tytXdobjY8oaouUMW10Ntc/bf+sOZ0Pbb
	Wf0hRo9TeSkj+4rJ5FRiZOqLjkfptghQn0B4qfa/PPNgUI5sLodtMTyIzVk4aJ2Iike51Ma2lmEPy
	fb1C0QzA==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
	by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <gunthorp@deltatee.com>)
	id 1sEXBT-000frr-0f;
	Tue, 04 Jun 2024 10:38:52 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.96)
	(envelope-from <gunthorp@deltatee.com>)
	id 1sEXBG-003Lem-1X;
	Tue, 04 Jun 2024 10:38:38 -0600
From: Logan Gunthorpe <logang@deltatee.com>
To: linux-raid@vger.kernel.org,
	Jes Sorensen <jes@trained-monkey.org>,
	Xiao Ni <xni@redhat.com>
Cc: Guoqing Jiang <guoqing.jiang@linux.dev>,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
	Logan Gunthorpe <logang@deltatee.com>
Date: Tue,  4 Jun 2024 10:38:35 -0600
Message-Id: <20240604163837.798219-1-logang@deltatee.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jes@trained-monkey.org, xni@redhat.com, guoqing.jiang@linux.dev, mariusz.tkaczyk@linux.intel.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
X-Spam-Level: 
Subject: [PATCH mdadm 0/2] Bug fixes for --write-zeros option
X-SA-Exim-Version: 4.2.1 (built Wed, 06 Jul 2022 17:57:39 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)

Hi,

Xiao noticed that the write-zeros tests failed randomly, especially
with small disks. We tracked this down to an issue with signalfd which
coallesced SIGCHLD signals into one. This is fixed by checking the
status of all children after every SIGCHLD.

While we were at it, we noticed a potential reace with SIGCHLD coming
in before the signal was blocked in wait_for_zero_forks() and fix this
by moving the blocking before the child creation.

Thanks,

Logan

--

Logan Gunthorpe (2):
  mdadm: Fix hang race condition in wait_for_zero_forks()
  mdadm: Block SIGCHLD processes before starting children

 Create.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)


base-commit: 46f19270265fe54cda1c728cb156b755273b4ab6
--
2.39.2
