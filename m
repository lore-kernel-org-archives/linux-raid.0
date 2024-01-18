Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478A417C3
	for <linux-raid@vger.kernel.org>; Thu, 18 Jan 2024 01:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705540393; cv=none; b=KSRL2Le0+THOiAO8E5ILitKNppplgVuTLESXSyCCoT/01GF+tynre6WIJeXVRI/1KXZ4sqRJtguGTHGeYZw5LR3lKgOmFI1gUsFUPcwIwOeqphxV3bdUDeql6Jslx6Gj6R/B0t1nRKeIwYGW2HpwlMtV+X8NBTJarZ2WikRqLrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705540393; c=relaxed/simple;
	bh=U1Z5i/krwXMsD1z2hq6zUHl9/zMQNP9/EtuaV8RY75M=;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:
	 X-Google-Smtp-Source:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gmail-Original-Message-ID:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding; b=qWke8mYnEm1tz0TkVB6j+JmR98YXGaHUpNvl4s6WSUo4EYF9mlrHCfdrsLrJezEkv+0plLl6Kb5ml9wskrOnhdOGWJdix60tCA6DvtBOUb/LIGZT79Xlm95E0wTPblsmSO7XenQprTdZmmWNH2eHylZx+QPoijQhTwVLWebAh1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eK4TAHzZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eK4TAHzZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9399C43390
	for <linux-raid@vger.kernel.org>; Thu, 18 Jan 2024 01:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705540392;
	bh=U1Z5i/krwXMsD1z2hq6zUHl9/zMQNP9/EtuaV8RY75M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=eK4TAHzZjtjmA8dzrJUtiscfpjzW3nCaaAYHG0jWnza/ceyoYZXlTpfi6qgVuzG4B
	 wYlctnAIbsh2ezbbvor0z1/nDxnwKrGjYIVyLoE0Zh4tcgLBwJKF754xXRTZ5+WfC4
	 1H1poerwBIyo4lXAHo7XSFT+Zn3lWgo6R+uBwBGVL+IaKOTkm/sYrzhHPYH/1TNlXQ
	 iulRL1GrxnJhr3gkHO2CslhxHKyYUTLdw/pJXAJWuL27BuD4ypcs6+QBVoeaMce1M5
	 lN+rHcFUSe91vG3FBJ42mRdYBi3lSe3UsecmC5+8xDMS6i29oJIR+lW5JAk9AjLRJU
	 c5VDP33Q70rAg==
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-50e67e37661so16304672e87.0
        for <linux-raid@vger.kernel.org>; Wed, 17 Jan 2024 17:13:12 -0800 (PST)
X-Gm-Message-State: AOJu0YygZAvXlTvpjl2CK68mot04Mf3V97XSZRwgqf5WqCf1UfaK6spR
	CI/6cOyys5k1m7YqlWjE2qXX/PJ8lTuq3CsAGBZ/aXkolDgqT4Wf70mscRd/adsr2rmMJEw970I
	d2UtYkCNQMWgxEAccow/lR7NJ/Zg=
X-Google-Smtp-Source: AGHT+IHXfGnnQ4BHNPYNwWzfe1cjtRbnf/JF2/OCld0syQO6pN2U6IP9uHROl3emTxuD2adk8RH2ZvFWLaf75ZYweI0=
X-Received: by 2002:a05:6512:3e1e:b0:50e:db50:3b84 with SMTP id
 i30-20020a0565123e1e00b0050edb503b84mr38321lfv.100.1705540390985; Wed, 17 Jan
 2024 17:13:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com> <ece2b06f-d647-6613-a534-ff4c9bec1142@redhat.com>
In-Reply-To: <ece2b06f-d647-6613-a534-ff4c9bec1142@redhat.com>
From: Song Liu <song@kernel.org>
Date: Wed, 17 Jan 2024 17:12:59 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6TtWVKggBSa5vhuve69cjMRzUFPWcLQ7VH39mpp9gpqQ@mail.gmail.com>
Message-ID: <CAPhsuW6TtWVKggBSa5vhuve69cjMRzUFPWcLQ7VH39mpp9gpqQ@mail.gmail.com>
Subject: Re: [PATCH 5/7] md: fix deadlock in shell/lvconvert-raid-reshape-linear_to_raid6-single-type.sh
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Yu Kuai <yukuai3@huawei.com>, David Jeffery <djeffery@redhat.com>, 
	Li Nan <linan122@huawei.com>, dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, 
	Mike Snitzer <msnitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, 
	Benjamin Marzinski <bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 17, 2024 at 10:21=E2=80=AFAM Mikulas Patocka <mpatocka@redhat.c=
om> wrote:
>
> This commit fixes a deadlock in the LVM2 test
> shell/lvconvert-raid-reshape-linear_to_raid6-single-type.sh

I can reproduce this issue on the 6.7 kernel. However, 4/7 and 5/7
(without 1/7-3/7)
cannot fix it. I will run more tests.

Thanks,
Song
