From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: [PATCH] md: Combine two kmalloc() calls into one in sb_equal()
Date: Fri, 9 Dec 2016 20:09:58 +0100
Message-ID: <71044708-c5e4-3a14-b162-dfc600311a60@fastmail.fm>
References: <f4df733d-8e06-8ba1-c4c3-800d8c5615ba@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f4df733d-8e06-8ba1-c4c3-800d8c5615ba@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>, linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids



On 09.12.2016 19:30, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 9 Dec 2016 19:09:13 +0100
>
> The function "kmalloc" was called in one case by the function "sb_equal"
> without checking immediately if it failed.

Err, your patch actually *replaces* the check. So where did you get the 
idea from that it is not checked immediately?

[...]

> -	tmp1 = kmalloc(sizeof(*tmp1),GFP_KERNEL);
> -	tmp2 = kmalloc(sizeof(*tmp2),GFP_KERNEL);
> -
> -	if (!tmp1 || !tmp2) {
> -		ret = 0;
> -		goto abort;
> -	}

This is not immediately?



Bernd
