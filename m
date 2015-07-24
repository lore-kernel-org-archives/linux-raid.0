From: Gionatan Danti <g.danti@assyoma.it>
Subject: Re: [PATCH] raid0: data corruption when using trim
Date: Fri, 24 Jul 2015 08:47:44 +0200
Message-ID: <55B1DF90.7090904@assyoma.it>
References: <013e01d0c1d2$f3af4fb0$db0def10$@samsung.com> <yq1y4ibknz4.fsf@sermon.lab.mkp.net> <005601d0c36c$59d28ec0$0d77ac40$@samsung.com> <yq1wpxu154v.fsf@sermon.lab.mkp.net> <005601d0c470$951ea860$bf5bf920$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <005601d0c470$951ea860$bf5bf920$@samsung.com>
Sender: linux-raid-owner@vger.kernel.org
To: Seunguk Shin <seunguk.shin@samsung.com>, "'Martin K. Petersen'" <martin.petersen@oracle.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, g.danti@assyoma.it
List-Id: linux-raid.ids

> Martine,
>
> I have tested the script from Algolia with your patch, I cannot see the same
> symptoms I saw with original kernel. I think the patch works and there is no
> problem.
>
> Thank you,
> Seunguk Shin
>

Hi, any idea on why the bug affects/manifests only on specific SATA 
SSDs? It is timing related, or it depends on how the controller manage 
TRIM requests?

Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
