Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F7C250E1
	for <linux-raid@vger.kernel.org>; Thu, 18 Jan 2024 13:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705583258; cv=none; b=G3/N/S0LTD+ccxTwepqH9Bg5lmLtZrGQ6XMW6DlQzOz3KhtTlO0+DIr6LS/ksu7cE8k4r4hozDVAbp7tw6TlD8c0VGWnAao9qQTtc665osk51pnhmaq781FipG+Ui7jntLoYyf+HKp/99BG1JPvW2LXfcFgr7nI4DCkgC0aLQqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705583258; c=relaxed/simple;
	bh=1FhKSlwdqM2HAjbFVWUQ6/ZDQ4seBXrE/UY63G6Ex34=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:Received:Received:
	 Received:Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type:X-Scanned-By; b=bwQ5s+S1IaVzs9F9HkdnHXeQE0OCWiNj1P/sJNJVpxNJUO+WjJ8zqEIF1Fat8k7x3Ol20PfUlmM7vaaL4+BUgCoS/HQcl9a4R6FGo+HIMfvMIC9JrPleeEIzphuMI638cXeFV7DNTSHeqnXoSMzLdJ0TX3oDD8YRzqtUBEX0VCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BkG93mWK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BkG93mWK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705583256;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VExoJBKhM2VGSreOTmpBtRNasbnC/MNtr+/gJyFW3fU=;
	b=BkG93mWKMJgEaClPvzbQf10NOIn4LsHZ/aU3SYwFUNtyBKBpAHJOLaY1Ug9ZCYVOW7OBIX
	rlxqAxnTJNHALnUPot3863bt4LoPIL+gWN3dFBlHvK7rTS6gaY4B/jfPGGKfZrgJZ1/gnx
	GClK0NHDbdoXD8tT45ri5B5q9vCekYY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-124-7qJKrgaGPiOdTDngx87dYA-1; Thu, 18 Jan 2024 08:07:32 -0500
X-MC-Unique: 7qJKrgaGPiOdTDngx87dYA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B56F85A589;
	Thu, 18 Jan 2024 13:07:32 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F3DFA111FF;
	Thu, 18 Jan 2024 13:07:31 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id A4C3130C1B8F; Thu, 18 Jan 2024 13:07:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id A06B33FFC5;
	Thu, 18 Jan 2024 14:07:31 +0100 (CET)
Date: Thu, 18 Jan 2024 14:07:31 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
cc: Song Liu <song@kernel.org>, David Jeffery <djeffery@redhat.com>, 
    Li Nan <linan122@huawei.com>, dm-devel@lists.linux.dev, 
    linux-raid@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>, 
    Heinz Mauelshagen <heinzm@redhat.com>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH 2/7] md: fix a race condition when stopping the sync
 thread
In-Reply-To: <dcf29bba-4762-84ad-f60e-3607cf6779f9@huaweicloud.com>
Message-ID: <66fda537-9d25-77e7-754f-2627e35fb8a4@redhat.com>
References: <e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com> <8fb335e-6d2c-dbb5-d7-ded8db5145a@redhat.com> <dcf29bba-4762-84ad-f60e-3607cf6779f9@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="185210117-611424774-1705583251=:1547117"
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--185210117-611424774-1705583251=:1547117
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8BIT



On Thu, 18 Jan 2024, Yu Kuai wrote:

> Hi,
> 
> ÔÚ 2024/01/18 2:18, Mikulas Patocka Ð´µÀ:
> > Note that md_wakeup_thread_directly is racy - it will do nothing if the
> > thread is already running or it may cause spurious wake-up if the thread
> > is blocked in another subsystem.
> 
> No, as the comment said, md_wakeup_thread_directly() is just to prevent
> that md_wakeup_thread() can't wake up md_do_sync() if it's waiting for
> metadata update.

Yes - but what happens if you wake up the thread just a few instructions 
before it is going to sleep for metadata update? wake_up_process does 
nothing on a running process and the thread proceeds with waiting. This is 
what I thought could happen when I was making the patch.

Mikulas
--185210117-611424774-1705583251=:1547117--

