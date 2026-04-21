Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8993A1680
	for <linux-raid@vger.kernel.org>; Tue, 21 Apr 2026 09:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776762328; cv=none; b=rytockwqe3meIdwjIUWM/yJ0jMLOD02bSo46DjkI+N75mYjo8syQWMiO3prQfSF5bNja0UaELnwFmMQmxk9EIY7KEVb7az102q2H9ww+xiWGiq1FGNUtKWYiUk7KB7OOysnQ4zISTORHMFXrZaF+E1IcuxCpw32AgBU1GvOM/3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776762328; c=relaxed/simple;
	bh=jNS11TxrGCzC/ayr6dWUKwMQYFcjJbkoMNjsM92foRg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ht0B4d+QI1/hHajtWBAA/scuasz2eMPJ8ZhyLNhMfsej9cjxqCpR9D0v5f0ZnVPTDLl91rWqVV1Jh1Vov6Cq76PG0FFYKuyhf0exKsytQ6v8kz8B8BKTnzaNQPL4amX2mxCPoJRcpwI3PwfT6cX6v2YojPfwpkq6wvnCfM8th7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Xcc1CP1c; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Xcc1CP1c"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-441209fb77eso177888f8f.1
        for <linux-raid@vger.kernel.org>; Tue, 21 Apr 2026 02:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776762325; x=1777367125; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Bq9QG9cvLvgk2UCX7BCWel9Xe8wLb+Jo7joT5Pt0764=;
        b=Xcc1CP1cnpjrdwUmB5v0J4Irq7DUhlBQD21ey2Ch8Kf6N2zXz11+vDy6TZgmIaAUJC
         +zoEz8FhqsnU8ZDeplIlW5qDu4M1jS604a2J+/T4WHykYlPpreT7WCgIS73DUOordZhU
         GSQpP79dJgdMCPtm+L0j6TbNe5PuLwUFNi+EpHD1QPWzLgzk5WJ2OJHQfvHv7r2ufHNM
         nX6nSDXwcL1hB+Q6aa5W7/7q/7STQTSZPxNsZMvv51vHikW+kMIXBLc6pQtRVKpk8XIr
         0PPbT4gMMmh5vdD5GsAgJgoWAemXJ+aXAnYSthNEwj6jZRtccCdx87/R/FK10xXMgnxj
         3nYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776762325; x=1777367125;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bq9QG9cvLvgk2UCX7BCWel9Xe8wLb+Jo7joT5Pt0764=;
        b=k86krrYUkjysbWyGq9vdF8jO5hQs9E626pNnD1hUIqp0VG7nwBFhnvb752f2vHv+Gw
         hfizkpTIcd1pXtHW0fhm4X5VnKKPMwkbdaPuz9gU/QyO1J29Cb8fB5wQ/2GTlgB+WnOW
         uoPGLE3XRp5vx5N351GjD93oUjIWbWddt5nCnTjbzvnf3lxVkF7X8T84vBoLEns0tENo
         X6Yo+wjF36CTAuXQe1JJuxUiDqWO6ExGSWlMuIfA4gtVxx6U2pnbIrccO0xKbZDX5T/o
         YhFv6wNLHekt3EnNv1gqd59zGX3jR1ir2EVw7k+Psh5ZHOloOWZMSBJPhMv4Ib/k3/6v
         G5VA==
X-Forwarded-Encrypted: i=1; AFNElJ/TZdvjUCOu2rBfalU8mn2ll8ffzuXQSb8rpx++xU4cNtKWOJNGon4j3TDLwyvoOK7DQQSAuQc5/QBg@vger.kernel.org
X-Gm-Message-State: AOJu0YycDtUqM7B9rI0IjwV4UarSvmOGYLV2ecBMgZQ5pAoNM4AmAsD4
	QlPz8zPP1jTnksiUtRhdWINOdlRGgY1/rrIVDWLc1pdgEHtcJXaGsevLuH+f177W8p4=
X-Gm-Gg: AeBDievSfaJyIlultAHC4JnsYuflkpDyl3HFL3dFbo3FLYkRFo5iHUwmiuf/6BEK1sa
	Vy2Ud2j8M+L9sYXu8ddIi88I4wkroQqmHdfMX1GmyV67t88uZgR3hKpvnv63xpcqiijFeAPhae7
	Hy1dp6XY/SDHmEICKypdrYZZOYxWD7aFh7BJixZ/hlgW28x1Zqg3qi8zP4cJO33tumqNu0GmnWi
	Mn9QSCE6mwuc8URVu9WsOUKKqqkMYjwao5sBh6euohU5V+EhkFQY65ifOsD+uT45cc9FcDz9LIc
	1eX9XVmd/KmhZR53adrE43hWGvUy/t5qSaL1cpo0VdAW6+KusR3+6Qq+0b8AaoBs5K4QMzlahiP
	CM3oMuerwfO2LmL/96xnP8HFHj7HS1xX3GR4CKEOa5AmGG0SjvpNFkdLNs0BfpbIGeCmoaoHtgN
	6DBtBb4XA2eHs6zc9I1MWQaIg6iCwlUII6bcRDxYY/rwrzkP56wlI=
X-Received: by 2002:a5d:5c81:0:b0:43d:729e:f23a with SMTP id ffacd0b85a97d-43fe408dab9mr19081632f8f.22.1776762324596;
        Tue, 21 Apr 2026 02:05:24 -0700 (PDT)
Received: from pathway.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cb135asm39945351f8f.6.2026.04.21.02.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 02:05:24 -0700 (PDT)
Date: Tue, 21 Apr 2026 11:05:21 +0200
From: Petr Mladek <pmladek@suse.com>
To: Masami Hiramatsu <mhiramat@kernel.org>
Cc: chensong_2000@189.cn, rafael@kernel.org, lenb@kernel.org,
	mturquette@baylibre.com, sboyd@kernel.org, viresh.kumar@linaro.org,
	agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
	bmarzins@redhat.com, song@kernel.org, yukuai@fnnas.com,
	linan122@huawei.com, jason.wessel@windriver.com, danielt@kernel.org,
	dianders@chromium.org, horms@kernel.org, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	paulmck@kernel.org, frederic@kernel.org, mcgrof@kernel.org,
	petr.pavlu@suse.com, da.gomez@kernel.org, samitolvanen@google.com,
	atomlin@atomlin.com, jpoimboe@kernel.org, jikos@kernel.org,
	mbenes@suse.cz, joe.lawrence@redhat.com, rostedt@goodmis.org,
	mark.rutland@arm.com, mathieu.desnoyers@efficios.com,
	linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
	linux-clk@vger.kernel.org, linux-pm@vger.kernel.org,
	live-patching@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
	netdev@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] kernel/notifier: replace single-linked list with
 double-linked list for reverse traversal
Message-ID: <aec90caYZDHDAHgw@pathway.suse.cz>
References: <20260415070137.17860-1-chensong_2000@189.cn>
 <20260420144429.57b45f2beece690bceea96ec@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420144429.57b45f2beece690bceea96ec@kernel.org>

On Mon 2026-04-20 14:44:29, Masami Hiramatsu wrote:
> Hi Song,
> 
> On Wed, 15 Apr 2026 15:01:37 +0800
> chensong_2000@189.cn wrote:
> 
> > From: Song Chen <chensong_2000@189.cn>
> > 
> > The current notifier chain implementation uses a single-linked list
> > (struct notifier_block *next), which only supports forward traversal
> > in priority order. This makes it difficult to handle cleanup/teardown
> > scenarios that require notifiers to be called in reverse priority order.
> 
> What about introducing a new notification callback API that allows you
> to describe dependencies between callback functions?
> 
> For example, when registering a callback, you could register a string
> as an ID and specify whether to call it before or after that ID,
> or you could register a comparison function that is called when adding
> to a list. (I prefer @name and @depends fields so that it can be easily
> maintained.)

This looks too complex. It would make sense only
when this API has more users.

Also this won't be enough for the ftrace/livepatch callbacks.
They need to be ordered against against each other. But they
also need to be called before/after all other callbacks.
For example, when the module is loaded:

   + 1st frace
   + 2nd livepatch
   + then other notifiers

See the commit c1bf08ac26e92122 ("ftrace: Be first to run code
modification on modules").

> This would allow for better dependency building when adding to the list.
 
> > 
> > A concrete example is the ordering dependency between ftrace and
> > livepatch during module load/unload. see the detail here [1].
> 
> If this only concerns notification callback issues with the ftrace
> and livepatch modules, it's far more robust to simply call the
> necessary processing directly when the modules load and unload,
> rather than registering notification callbacks externally.
> 
> There are fprobe, kprobe and its trace-events, all of them are using
> ftrace as its fundation layer. In this case, I always needs to
> consider callback order when a module is unloaded.
> 
> If ftrace is working as a part of module callbacks, it will conflict
> with fprobe/kprobe module callback. Of course we can reorder it with
> modifying its priority. But this is ugly, because when we introduce
> a new other feature which depends on another layer, we need to
> reorder the callback's priority number on the list.
> 
> Based on the above, I don't think this can be resolved simply by
> changing the list of notification callbacks to a bidirectional list.

I agree. I would keep it as is (hardcoded).

Best Regards,
Petr
