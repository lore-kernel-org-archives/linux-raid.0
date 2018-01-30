From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: Can anyone help me review my patch?
Date: Tue, 30 Jan 2018 13:58:46 +0800
Message-ID: <7570e9a5-246a-e5fe-fd5c-f9785854ea9b@suse.com>
References: <5a6ff22a.8964650a.8e834.d526@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5a6ff22a.8964650a.8e834.d526@mx.google.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: liuchaowei110@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 01/30/2018 12:17 PM, liuchaowei110@gmail.com wrote:
> Hello, everyone:
>      I'm very glad and excited to send this email because this is my
> first time to send a email in linux-raid email list, and recently I
> have a new driver code about dm-stripe/raid0 want to upload. I've
> been uploaded to the mail list this ahead of month, but only one guy
> give me an advice. But after then no one give any feedback, I feel
> frustrated. So can anyone help me review or check my patch?
> Follow is the patch:
>
> https://marc.info/?l=linux-raid&m=151455106025351&w=2
> https://marc.info/?l=linux-raid&m=151455110725361&w=2
> https://marc.info/?l=linux-raid&m=151455110625360&w=2
>
> This patch is about dm-stripe/raid0, it will help enhance io performance
> if you want to combine storage device between slow and fast devices.
>
> I'm looking forward to receiving anyone's suggestion.

You need to send them to dm-devel@redhat.com instead of raid list, and
./scripts/get_maintainer.pl can tell you the right list for the patch.

Thanks,
Guoqing
