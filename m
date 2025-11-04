Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5456E2EC541
	for <linux-raid@vger.kernel.org>; Tue,  4 Nov 2025 12:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762257898; cv=none; b=c35Cdfkr5LIhqZgD5xX4gDGQq34vHRpr8KedDpNyDNHNFcdJOF6HINIiWfxTcHknftBotgk1GfawSJCZMG+957V0d7CVoENgxYbOjlbp16bb+2/DTszH8UZ9OaveZgGUySlqo09zS2FJlXChrHMutA3PZjao4Bq6C3DKMPx4LaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762257898; c=relaxed/simple;
	bh=91j83r0a/744GsjSSpvMj2vPPbbmwRCLqH0NKKKQxTs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=K8/octdNImSsRwmFjvmz95LciYZnwqM5ztiviKvLT8YuSNjha1wtSiWZU/CsHb3PzDRIqg6qMIoPEIpjqQWC2deb8ba490X8Ealtrn6e2rmYkpPj+cgdvsEtxVEUg3x14989uxAe5oDiptxzFoDb6yPSlnPF8TZcFDRuS3rE+Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VfPVlvIU; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VfPVlvIU"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-29586626fbeso22755805ad.0
        for <linux-raid@vger.kernel.org>; Tue, 04 Nov 2025 04:04:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762257897; x=1762862697; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hIMOgpEtwvgPznTb3R/noQ8H3QESHZcJ3b2FNe/UuI0=;
        b=VfPVlvIUyTV8qIihY9JjSsKeyNBWMl6UMFmRHCYWXD/joLcLMadxUuigePc7OhaZrY
         poj39NwZlF7+axyTDmSBJZ4OAlWaIr7WNFIwvrpEi3HxnWPGVIBY+gLnWoFBRlDDThYl
         j5zBzjXV9t/sahOazDTvFdKATZUWOqVN1tY2AzxYG1MId0HMuxoSEe2F6b82KB1ne/h+
         LEDmMa4nPJ6uRvAYKezrrO6KUc7QMaqhzHqVkUS40HQUtiFYcPk+XmZH/a9FvXU2/hf4
         6a80ov5PHP2a0+LlvS8un7oaNXSNfvizKWZKs7QCnHqx/okdk249o3XS+QCDKsBfTnTM
         /yXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762257897; x=1762862697;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hIMOgpEtwvgPznTb3R/noQ8H3QESHZcJ3b2FNe/UuI0=;
        b=Jy+z/J12EcxFD+av/WtGdD1Exqjj/nGdKMENjx6eL5kAQBjuLicTXx/WXXqIBG9bMr
         3mnmxnQ307lZDYH8PHTUjXkwLdNYEs1VsfJkT177Z9kSvUWPA84flFGVZWzV/ob/1OcP
         zKEJBe9yvqV9qi1npRXLUm+NcbieSUCxiiJx9QtTHOPsf5tDqnT5sto1jQyS8SkaXs12
         M50DCHJjHFFrDMjZdpa/lmfbTHZIvUvHKWSaN3HbO004P++36lhA6UIaGFdq0QckONkA
         MwTeKlCEHPaH3YBE77O1bR9py7Km8wbpj0VgEPNFhHH3ZNph8ZT5Djox+npfjYlx90y+
         XPkA==
X-Forwarded-Encrypted: i=1; AJvYcCXZaxBAXEWya8ThGf6JW9Fc6xol3mosULcFgMZ9zq00EwQUBkaTT1LhthA2y4ukcb7c7fVa5CLA80KN@vger.kernel.org
X-Gm-Message-State: AOJu0YxVDNORSUqlPKlnkaIyqw4xJA8lxR7ZtbMEugXcr8lLnNKoWzfZ
	eAMtn4ylNAD6xOzN2cGyqnmR5YnWurB/dUC3j8hhIRMxO4MpY6FNPh1U
X-Gm-Gg: ASbGnculfqy9uCrgk/XmSiQIc+C2D/OzoHmqfxCSsVg2QGyHPNI/1rNw+C66HyTBuyC
	zpqotsLkW6oKmKm++8K8qJEv17riGYbBJDOwiheXmCi2b8eZ9gCz0+ytuMpPt6leTl3Y1EQQOu6
	x+0dDYP9G9TIP5CitJT9XcLeROG5irMb+Oyx5zedrf01eBbNRionUgl3PItO7DB5WSILdnsTgmv
	o4m5+JnfKf29hNukbPWrLpSfepQWhyVLun1QoqamAeKWTD1xu61u2+YljHkoCq4IfpyCE4VC/Jp
	H1VrqvQcgkgnqtX3lBEOclXkcEcl26w82H0tBSFrWg+vVaqt75Y/0+I21wUA0m8ZJNX2vIPBpC+
	hsTDk+EXqRbC1BrMR12az7YStvT2TIXFdDW7HprpaNyh0rEBWHeQ6hLEfSDPvTwSfodP9v3iMVb
	8B3ScWSmXu+M9mQZF/0T2z0dNcQpR3MezyZOKKL328P1kSgwF0E36JbA==
X-Google-Smtp-Source: AGHT+IHhptMGeN6GUWdSr3woSCYhxUw05Wn9RRD4O2T5DayZS0jhPNbaRMV4ZHTfd4sd7Ew85mCkaw==
X-Received: by 2002:a17:902:e88e:b0:295:fe33:18bb with SMTP id d9443c01a7336-295fe331993mr38565105ad.14.1762257896410;
        Tue, 04 Nov 2025 04:04:56 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.200.106])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2960199831esm24707045ad.37.2025.11.04.04.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 04:04:55 -0800 (PST)
Message-ID: <a05cde7d15d85f2cee6eafdb69b1380c8b704207.camel@gmail.com>
Subject: Re: [PATCH 2/4] fs: return writeback errors for IOCB_DONTCACHE in
 generic_write_sync
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Christian Brauner
 <brauner@kernel.org>,  Jan Kara <jack@suse.cz>, "Martin K. Petersen"
 <martin.petersen@oracle.com>,  linux-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
 linux-raid@vger.kernel.org,  linux-block@vger.kernel.org
Date: Tue, 04 Nov 2025 17:34:50 +0530
In-Reply-To: <20251029163708.GC26985@lst.de>
References: <20251029071537.1127397-1-hch@lst.de>
	 <20251029071537.1127397-3-hch@lst.de>
	 <20251029160101.GE3356773@frogsfrogsfrogs> <20251029163708.GC26985@lst.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2025-10-29 at 17:37 +0100, Christoph Hellwig wrote:
> On Wed, Oct 29, 2025 at 09:01:01AM -0700, Darrick J. Wong wrote:
> > Hum.  So we kick writeback but don't wait for any of it to start, and
> > immediately sample wberr.  Does that mean that in the "bdev died" case,
> > the newly initiated writeback will have failed so quickly that
> > file_check_and_advance_wb_err will see that?
> 
> Yes, this is primarily about catching errors in the submission path
> before it reaches the device, which are returned synchronously.
So, what you are saying is file_check_and_advance_wb_err() will wait/block till the write back
request done in filemap_fdatawrite_range_kick() is completely submitted and there are no more
chances of write back failure?
--NR
> 
> > Or are we only reflecting
> > past write failures back to userspace on the *second* write after the
> > device dies?
> > 
> > It would be helpful to know which fstests break, btw.
> 
> generic/252 generic/329 xfs/237
> 

