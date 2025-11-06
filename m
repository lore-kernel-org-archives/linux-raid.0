Received: from sg-1-18.ptr.blmpb.com (sg-1-18.ptr.blmpb.com [118.26.132.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F9828B7EA
	for <linux-raid@vger.kernel.org>; Thu,  6 Nov 2025 13:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762435852; cv=none; b=m/RhJNmnRDR+IePNsVzPtd1wtyxH0sZRS6MmtXKu5vq9oQo/FiwFb+XjVGc7RQvwBTJukEa1UTbyBXt4RAT8XVHfOZFMg4pKVds82FMQDfOPoLz9ywcztqKPWs3UJhGh7blgiLq84mORv8eamR5MoaQZH/STP9eF9kByuIGKnrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762435852; c=relaxed/simple;
	bh=r2L6JC/Rz40stNo3tTQ9hmYVh8zumvvXc+nrPbHyrEk=;
	h=From:Date:Mime-Version:Content-Type:In-Reply-To:To:References:
	 Subject:Message-Id:Cc; b=mem77YwRFQlSlNdZGOQaJo2nQd4a8G2i2Zh/CVuXENpZ27a9lNBkPdxsONWuribnRBEdSnbQZeo5GUxcDLvbPVLOBNC4yBTOK0pzMZPfiNUbjBE8DzU7yOEN+EKWIP2FTb7q5T6QBZCbhCQS9W2EitXGnAnTTM8e2gxNMSpNrl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=moLnTb0U; arc=none smtp.client-ip=118.26.132.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="moLnTb0U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1762435842;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=r2L6JC/Rz40stNo3tTQ9hmYVh8zumvvXc+nrPbHyrEk=;
 b=moLnTb0UwFY1nmb86jktYB5b3ch1VdLtUWW3qUMeZ27hYN0+FCc/jtzpToc6OoX+TVDMs7
 l/daMQr/P0GWObSwL58HoM8SlQPscDg1InviMYn3FtjuC0CRjZrFUL790yswqymSFFVNks
 NX7Kg2WReJ569U0NE9dm5k22grzt63ReViD92PJXt8qgF6IASH2vlq56Nv2NaRZ85rl9tX
 Vj5L6gAhBreB050d8TjaVEMzFs5h/hylcWuvzqsiFVfiNkL9HKLG2cQaZ1Ze51OYnPD9ju
 Wi3HLbq11xpyV3i4sHDhWUYzU6k+XxZbwoskGycOYKMvKM5ndx3hWOciXG91XQ==
Content-Transfer-Encoding: quoted-printable
Reply-To: yukuai@fnnas.com
From: "Yu Kuai" <yukuai@fnnas.com>
Date: Thu, 6 Nov 2025 21:30:37 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+2690ca300+36598a+vger.kernel.org+yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <CALTww2_MHcXCOjeOPha0+LHNiu8O_9P4jVYP=K5-ea951omfMw@mail.gmail.com>
To: "Xiao Ni" <xni@redhat.com>
References: <20251103125757.1405796-1-linan666@huaweicloud.com> <20251103125757.1405796-5-linan666@huaweicloud.com> <CALTww29-7U=o=RzS=pfo-zqLYY_O2o+PXw-8PLXqFRf=wdthvQ@mail.gmail.com> <a660478f-b146-05ec-a3f4-f86457b096d0@huaweicloud.com> <CALTww29v7kKgDyWqUZnteNqHDEH9_KBRY+HtSMJoquMv0sTwkg@mail.gmail.com> <2c1ab8fc-99ac-44fd-892c-2eeedb9581f4@fnnas.com> <CALTww289ZzZP5TmD5qezaYZV0Mnb90abqMqR=OnAzRz3NkmhQQ@mail.gmail.com> <5396ce6f-ba67-4f5e-86dc-3c9aebb6dc20@fnnas.com> <CALTww2_MHcXCOjeOPha0+LHNiu8O_9P4jVYP=K5-ea951omfMw@mail.gmail.com>
Received: from [192.168.1.104] ([39.182.0.168]) by smtp.feishu.cn with ESMTPS; Thu, 06 Nov 2025 21:30:39 +0800
Subject: Re: [PATCH v9 4/5] md: add check_new_feature module parameter
Message-Id: <c3124729-4b78-4c45-9b13-b74d59881dba@fnnas.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Cc: "Li Nan" <linan666@huaweicloud.com>, <corbet@lwn.net>, <song@kernel.org>, 
	<hare@suse.de>, <linux-doc@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-raid@vger.kernel.org>, 
	<yangerkun@huawei.com>, <yi.zhang@huawei.com>, <yukuai@fnnas.com>

Hi,

=E5=9C=A8 2025/11/6 21:15, Xiao Ni =E5=86=99=E9=81=93:
> In patch05, the commit says this:
>
> Future mdadm should support setting LBS via metadata field during RAID
> creation and the new sysfs. Though the kernel allows runtime LBS changes,
> users should avoid modifying it after creating partitions or filesystems
> to prevent compatibility issues.
>
> So it only can specify logical block size when creating an array. In
> the case you mentioned above, in step3, the array will be assembled in
> new kernel and the sb->pad3 will not be set, right?

No, lbs will be set to the value array actually use in metadata, otherwise
data loss problem will not be fixed for the array with different lbs from
underlying disks, this is what we want to fix in the first place.

Thanks,
Kuai
