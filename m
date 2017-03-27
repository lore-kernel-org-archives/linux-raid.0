From: SeongJae Park <sj38.park@gmail.com>
Subject: Re: [PATCH 0/5] Fix dead URLs to ftp.kernel.org
Date: Mon, 27 Mar 2017 21:42:48 +0900
Message-ID: <CAEjAshqR0Nhp4Wkmkg_HrswsiuUb3rYJ=TOUSBSvoUT3FSWTjg@mail.gmail.com>
References: <20170327054731.31882-1-sj38.park@gmail.com> <fabba6b8-8f8d-8f8f-1660-c579e6515563@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <fabba6b8-8f8d-8f8f-1660-c579e6515563@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Marek <mmarek@suse.com>
Cc: rml@tech9.net, axboe@fb.com, shli@kernel.org, Ian Kent <raven@themaw.net>, yamada.masahito@socionext.com, linux-raid@vger.kernel.org, autofs@vger.kernel.org, linux-kbuild@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Mar 27, 2017 at 8:54 PM, Michal Marek <mmarek@suse.com> wrote:
> Dne 27.3.2017 v 07:47 SeongJae Park napsal(a):
>> URLs to `ftp.kernel.org` exist here and there though `ftp.kernel.org` is
>> already dead [0].  This patchset fixes those URLs to use `www.kernel.org`
>> instead.
>>
>> The change is splitted into multiple patches for independent review and merge
>> of each maintainer, though the change is trivial.
>>
>> [0] https://www.kernel.org/shutting-down-ftp-services.html
>>
>> SeongJae Park (5):
>>   MAINTAINERS: Fix a dead URL to ftp.kernel.org
>>   drivers/block: Fix a dead URL to ftp.kernel.org
>>   drivers/md: Fix a dead URL to ftp.kernel.org
>>   fs/autofs4: Fix a dead URL to ftp.kernel.org
>>   scripts: Fix dead URLs to ftp.kernel.org
>
> I guess the change be sent in a single patch to the trivial tree.

Sounds reasonable.  I will post the single patch as a reply to this mail.


Thanks,
SeongJae Park

>
> Michal
>
