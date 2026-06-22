Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E095391501
	for <linux-raid@vger.kernel.org>; Mon, 22 Jun 2026 08:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782117841; cv=none; b=AIer5UnZxkLhj3DNNNUkzrfz18W4aP2bl/dep7cW9VTkP8nKgqlLt4xS+JMYxoJ3mf3DEOCTMrRPx1V9b0+qc6k12cJS/yHeGoBUNCNEeBRck/JTdb9JG+e+foKOZ05LlV7UAiBH3H2VFhIcywxMTJoISnPu6dhJPKsTWxc4gf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782117841; c=relaxed/simple;
	bh=g0gRsy6zFiomxjase+ZA4WZlkxxDYp7gD/XOpVGQPhg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=heoUq0wS/gongLMF/ApQMVoXWRej9SinfzeV1HeM5psTTec8JtuAUH5Vz7Gp5Nc68R2F8PeU8NK4CMlHmOu1WVv2uwhjP21B6x37VpqSyW56cagQCHpB0bFA2ZFcAsbAbTGliekSTAhjOxBZ7WazJn8O/5TThsx3f+rF+cFGMAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ThoQw3BS; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ThoQw3BS"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-bec423a5265so728272566b.1
        for <linux-raid@vger.kernel.org>; Mon, 22 Jun 2026 01:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782117839; x=1782722639; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LR7honTOmyUatu9A73ADWJH5CaZ3n+G3Y/QkgDQI0TY=;
        b=ThoQw3BSct7YEZiR7/itBivH0CsJCVR1/ZJzjQJ0XshobWSBDKaJVnXNgCyf4l8e02
         BBdJwRCnZ30rKHwCHpquivQ11ATqTfNJJTwMo+yaeS97IXPyxWJDIwTivVeteZ1L8jFQ
         XPLPbu3Am31sBmezRRziogyEd13tBTE4/14qjKxuSkxdRZu5N3NxjS8JEZMm7ydnzpm1
         hNyUxrrlOcTrPwChHtJHTRZWRYcD5nyt/fG75saz7Goxod23zwfuyn8LlKt4QS1sMaFK
         DIb7d2EVn3Fra/E45tDaSGj2mQEJsoyMKhTkV6CsasJYzUBYsGEliL0lf9fp5wFN87fv
         g0+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782117839; x=1782722639;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LR7honTOmyUatu9A73ADWJH5CaZ3n+G3Y/QkgDQI0TY=;
        b=pcPGYGjwY9QNKyGy/fP/+Z97jctRlJGoit4vT7YltEc4EAZm4x9/nzlIMvylvgl9Rr
         ZgKBpXUSwexZ7b2gVOQf75gUi9Cj102NKDbBPH/SEfUYfrnK0VjKHBOa8t3ttct955j7
         vLRYEM6v0uO838Zv7JnPrqfbtoSZdR/LdEXMNib8uYOpRkxeOH6eacFBd446hVm369kT
         ctoF4fj7910qNHWwLIO2VpjPo9gC2eZuym9QZkNz/n0GNWnAGglQZA74fZFsqn/Yj5At
         1Thd5Z+Boeiew1Ru7uBRh3fy743f7cHx/ace0Wy95fKrhn+hAr4uaNM5U9bXCAR8SUep
         nbkA==
X-Gm-Message-State: AOJu0YxuIdxDW3cmliqQ/iugnmOx7yDzJhCB1uJt+hosIO8YU7md0uiw
	WU8xFfy6/uJvWLmaBqfS/2H7GrLBZgMCe0O2qTGD9uXkopvVHVXynlCf
X-Gm-Gg: AfdE7clHaX1c5wNuIU07kp5AehLbZWnAoOF4WmbkcuGr6jaXQsMOzMwPRHK0ya8W99c
	ALlBS11aqReASROZAn/guEOv+A74zqOq8N1sZ+flJUoQEDwpNzX9dyslsVCyK3iBn7X7Kjrznz0
	54/00vxLDDkZri2NvVWE31Xbq0qmC0/s0ZiL4109/8ir+N01X0pVGY3aiMLoXtSuTwY6KRUQohl
	ifH8+aL8lVU+7Gtr313qI5bXf0i1A6c+TnzuSY08NPwaCAnWULywAKZOFl7fGO36jx0r9hT6yI4
	+e1Ki4kYBRMQCFKuCzI6CSfDjcnCWBJ9xGeQ2iTdhmwb69dwBqZ0CsoRJR11nSlLnwvh6UzRpE/
	7JCudk/KWbeITjyYdLyZa+npr6Om4WKMzjZGJiEzGFo3S4e0j2rXS94PUQ/5ONFMCrZT9rulYwQ
	y9bbVRhU9x
X-Received: by 2002:a17:907:c12:b0:bfe:ed35:e859 with SMTP id a640c23a62f3a-c09904f9097mr699871766b.53.1782117838777;
        Mon, 22 Jun 2026 01:43:58 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c0c5ef8eb38sm313992266b.28.2026.06.22.01.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 01:43:58 -0700 (PDT)
Date: Mon, 22 Jun 2026 11:43:54 +0300
From: Dan Carpenter <error27@gmail.com>
To: Sajal Gupta <sajal2005gupta@gmail.com>
Cc: linux-raid@vger.kernel.org, song@kernel.org, yukuai3@huawei.com,
	tomasz.majchrzak@intel.com, linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org, me@brighamcampbell.com,
	linux-kernel-mentees@lists.linux.dev
Subject: Re: [PATCH] md/raid5-ppl: convert pending_flushes from atomic_t to
 refcount_t
Message-ID: <ajj1yljwrUk0bZwp@stanley.mountain>
References: <20260622080656.22786-1-sajal2005gupta@gmail.com>
 <ajj1WdhoW-Y3GE4Q@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajj1WdhoW-Y3GE4Q@stanley.mountain>

On Mon, Jun 22, 2026 at 11:42:01AM +0300, Dan Carpenter wrote:
> On Mon, Jun 22, 2026 at 01:34:32PM +0530, Sajal Gupta wrote:
> > The old atomic_t based counter allowed ppl_do_flush() to continue using io
> > after it could already have been freed by ppl_io_unit_finished(), leading
> > to a use-after-free.
> > 
> > Convert pending_flushes from atomic_t to refcount_t with a proper ownership
> > model. The creator holds a reference for the duration of ppl_do_flush(),
> > and each submitted flush bio holds a reference until its endio callback
> > runs. This makes the io lifetime explicit and removes the need for the
> > second loop in ppl_do_flush().
> > 
> > Fixes: 1532d9e87e8b ("raid5-ppl: PPL support for disks with write-back cache enabled")
> > Reported-by: Dan Carpenter <error27@gmail.com>
> > Closes: https://lore.kernel.org/all/ajJF2wKYWRk4GGCK@stanley.mountain/
> > Signed-off-by: Sajal Gupta <sajal2005gupta@gmail.com>
> > ---
> 
> Have you tested this at all because it doesn't seem at all correct to
> me...

How I imagined this would work would be:
patch 1: add a break statement to fix the use after free
patch 2: s/atomic_t/recount_t/

The difference between atomic_t and refcount_t is that refount_t warns
about overflows and underflows.

regards,
dan carpenter
