From: d tbsky <tbskyd@gmail.com>
Subject: Re: disk initialize priority
Date: Thu, 13 Apr 2017 18:25:44 +0800
Message-ID: <CAC6SzHLj4FL_=7FwSwvaziYAOs95hwhRgoG6qaZPvgMBsXJBsg@mail.gmail.com>
References: <CAC6SzHJAM-AbCiK7rqhgk4CJcyZ4C-yW0kt_rr3hgk+F-WMCiQ@mail.gmail.com>
 <43e44c4b-37d6-9734-b323-5b432ef27d52@thelounge.net> <CAC6SzHKWeLMSn1Z3W0KyBaUw+5MLmnMxLbh130gxM071t8VeFw@mail.gmail.com>
 <fc31c172-f988-32a4-c9b2-93bc7f3bfc90@thelounge.net> <20170413150514.6b92d81f@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170413150514.6b92d81f@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: Reindl Harald <h.reindl@thelounge.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2017-04-13 18:05 GMT+08:00 Roman Mamedov <rm@romanrm.net>:
> On Thu, 13 Apr 2017 11:47:29 +0200
> Reindl Harald <h.reindl@thelounge.net> wrote:
>
>> and?
>>
>> you said it is at 200000
>> i showed you how to reduce it to 50000 or whatever you want
>
> The point is that this should automatically adjust between 1000 and 200000 (on
> default settings) according to other IO in the system. But since April 2015
> this automatic tuning got broken and has worsened significantly for some
> scenarios. The solution should be not that "well you're SOL and now always
> have to hand-tune it", but to keep reporting your experience and try out the
> proposed fixes so the prior automated adjustment is reimplemented, or baring
> that, to revert the behavior change on your systems (already tried that just
> now on my kernel build, it still reverts cleanly).
>
> --
> With respect,
> Roman

hi:
     RHEL 7 use kernel 3.10 so it should not be affected. at least
RHEL 7.2 I didn't notice this kind of problem. maybe RHEL 7.3 pull
some feature/patch from upstream kernel. I will try to report to
redhat bugzilla to see if they can fix these.

     thanks again for all the hints and help!!

Regards,
tbskyd
