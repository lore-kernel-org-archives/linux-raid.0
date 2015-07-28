From: Guoqing Jiang <gqJiang@suse.com>
Subject: Re: [PATCH 12/12] md-cluster: handle error situations more precisely
 in lockres_init
Date: Tue, 28 Jul 2015 11:05:13 +0800
Message-ID: <55B6F169.50806@suse.com>
References: <1436518453-12660-1-git-send-email-gqjiang@suse.com> <1436518883-12783-1-git-send-email-gqjiang@suse.com> <1436518883-12783-9-git-send-email-gqjiang@suse.com> <55B65D9F.7010009@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55B65D9F.7010009@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Goldwyn,

> On 07/10/2015 04:01 AM, Guoqing Jiang wrote:
>> In lockres_init, it's better to distinguish different err conditions.
>>
>> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
>
> This is not required. kfree() is capable of ignoring null pointers.

Right, I missed about that.

Thanks,
Guoqing
