From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3 0/3] Fix typo in RWH_WRITE_LIFE_NOT_SET constant name
Date: Fri, 25 Oct 2019 14:21:34 -0600
Message-ID: <87964005-1790-007b-4117-3b6abbb67f36@kernel.dk>
References: <cover.1568994791.git.esyr@redhat.com>
 <CAPhsuW5CvJNRP5OO_M6XVd9q0x-CH9eADWR5oqdJP20eFScCFw@mail.gmail.com>
 <87d4b42f-7aa2-5372-27e4-a28e4c724f37@kernel.dk>
 <CAPhsuW68rK3zGF3A8HnwArh7bs+-AAvZBtVkt4gcxPnFCGxwAQ@mail.gmail.com>
 <CAPhsuW6ZSbKLYPpUk3DT+HxTfcuOVPG64rQ057aoLGgrGSeGHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAPhsuW6ZSbKLYPpUk3DT+HxTfcuOVPG64rQ057aoLGgrGSeGHA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Song Liu <liu.song.a23@gmail.com>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>
Cc: Eugene Syromiatnikov <esyr@redhat.com>, open list <linux-kernel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Arnaldo Carvalho de Melo <acme@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@kernel.org>, linux-raid <linux-raid@vger.kernel.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-raid.ids

On 10/16/19 11:00 AM, Song Liu wrote:
> Hi Jeff and J. Bruce,
> 
> On Wed, Oct 2, 2019 at 9:55 AM Song Liu <liu.song.a23@gmail.com> wrote:
>>
>> On Tue, Oct 1, 2019 at 5:55 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> On 10/1/19 5:12 PM, Song Liu wrote:
>>>> On Fri, Sep 20, 2019 at 8:58 AM Eugene Syromiatnikov <esyr@redhat.com> wrote:
>>>>>
>>>>> Hello.
>>>>>
>>>>> This is a small fix of a typo (or, more specifically, some remnant of
>>>>> the old patch version spelling) in RWH_WRITE_LIFE_NOT_SET constant,
>>>>> which is named as RWF_WRITE_LIFE_NOT_SET currently.  Since the name
>>>>> with "H" is used in man page and everywhere else, it's probably worth
>>>>> to make the name used in the fcntl.h UAPI header in line with it.
>>>>> The two follow-up patches update usage sites of this constant in kernel
>>>>> to use the new spelling.
>>>>>
>>>>> The old name is retained as it is part of UAPI now.
>>>>>
>>>>> Changes since v2[1]:
>>>>>    * Updated RWF_WRITE_LIFE_NOT_SET constant usage
>>>>>      in drivers/md/raid5-ppl.c:ppl_init_log().
>>>>>
>>>>> Changes since v1[2]:
>>>>>    * Changed format of the commit ID in the commit message of the first patch.
>>>>>    * Removed bogus Signed-off-by that snuck into the resend of the series.
>>>>
>>>> Applied to md-next.
>>>
>>> I think the core fs change should core in through a core tree, then
>>> the md bits can go in at will after that.
> 
> As Jens suggested, we should route core fs patches through core tree. Could
> you please apply these patches? Since the change is small, probably you can
> also apply md patches?
> 
> Thanks,
> Song
> 
> PS: for the series:
> 
> Acked-by: Song Liu <songliubraving@fb.com>

I applied 1/3 to the for-5.5/block core branch.

-- 
Jens Axboe
