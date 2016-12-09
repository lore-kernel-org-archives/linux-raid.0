From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: md: Combine two kmalloc() calls into one in sb_equal()
Date: Fri, 9 Dec 2016 22:18:14 +0100
Message-ID: <a33e87c6-9b47-96e2-a877-b86bc8949eb6@fastmail.fm>
References: <f4df733d-8e06-8ba1-c4c3-800d8c5615ba@users.sourceforge.net>
 <71044708-c5e4-3a14-b162-dfc600311a60@fastmail.fm>
 <a7693826-b1d1-882a-44ce-5dca9d2fe851@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a7693826-b1d1-882a-44ce-5dca9d2fe851@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids



On 09.12.2016 20:54, SF Markus Elfring wrote:
>> So where did you get the idea from that it is not checked immediately?
>
> Is another variable assignment performed so far before the return value
> is checked from a previous function call?

Irrelevant, the variable is not used before checking it.
