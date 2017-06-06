From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: mdadm: Apply to revert the commit of a4dcdb23
Date: Tue, 6 Jun 2017 12:02:15 -0400
Message-ID: <0d1a79b0-a7fd-656d-5cfd-a85b4398c284@gmail.com>
References: <0010fa6f-f227-cdd8-31ef-7073ec46546a@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0010fa6f-f227-cdd8-31ef-7073ec46546a@suse.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/06/2017 05:25 AM, Zhilong Liu wrote:
> Hi, Jes;
>     Excuse me, there is one problematic commit for Detail.c,
> a4dcdb23(Detail: determine array state from sysfs).
> This commit does change the codes meaning and it didn't
> run to the right path. This commit was result in a bug that
> Detail() cannot work normally.
> 
> For example:
> # ./mdadm -CR /dev/md0 -l1 -n2 /dev/loop[0-1] --assume-clean
> # ./mdadm -D /dev/md0
> mdadm: cannot get array detail for /dev/md0: No such file or directory
> 
> Thanks very much,
> -Zhilong

Please be more specific and explain what you believe is wrong. I prefer 
a patch fixing the issue to just reverting things.

Jes

