From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] raid0: data corruption when using trim
Date: Fri, 24 Jul 2015 11:03:13 -0400
Message-ID: <yq1zj2ly4we.fsf@sermon.lab.mkp.net>
References: <013e01d0c1d2$f3af4fb0$db0def10$@samsung.com>
	<yq1y4ibknz4.fsf@sermon.lab.mkp.net>
	<005601d0c36c$59d28ec0$0d77ac40$@samsung.com>
	<yq1wpxu154v.fsf@sermon.lab.mkp.net>
	<005601d0c470$951ea860$bf5bf920$@samsung.com>
	<55B1DF90.7090904@assyoma.it>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55B1DF90.7090904@assyoma.it> (Gionatan Danti's message of "Fri,
	24 Jul 2015 08:47:44 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Gionatan Danti <g.danti@assyoma.it>
Cc: Seunguk Shin <seunguk.shin@samsung.com>, "'Martin K. Petersen'" <martin.petersen@oracle.com>, neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Gionatan" == Gionatan Danti <g.danti@assyoma.it> writes:

Gionatan> Hi, any idea on why the bug affects/manifests only on specific
Gionatan> SATA SSDs?

Timing and a very heavy discard load.

-- 
Martin K. Petersen	Oracle Linux Engineering
