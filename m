From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] mdadm/md.4: set page-length as 1000 to avoid warnings
 from grotty
Date: Tue, 9 May 2017 10:53:02 -0400
Message-ID: <38a9316c-41e1-4c7f-a278-84e597db23e9@gmail.com>
References: <20170509062517.20755-1-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170509062517.20755-1-zlliu@suse.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/09/2017 02:25 AM, Zhilong Liu wrote:
> "nroff" ("man") or ("tbl") needs a long page to avoid warnings
> from "grotty", set 'pl' as 1000 to fix the following issue.
> 
> This command invokes by Makefile rule.
> linux-tjrh:~/mdadm # man -l md.4 > test
> grotty:<standard input> (<standard input>):5967:
> character above first line discarded
> ... ...
> 
> Signed-off-by: Zhilong Liu <zlliu@suse.com>

I am not an nroff expert, so I'll take your word for it.

Applied!

Thanks,
Jes

