From: Roman Mamedov <rm@romanrm.net>
Subject: Re: disk initialize priority
Date: Thu, 13 Apr 2017 15:05:14 +0500
Message-ID: <20170413150514.6b92d81f@natsu>
References: <CAC6SzHJAM-AbCiK7rqhgk4CJcyZ4C-yW0kt_rr3hgk+F-WMCiQ@mail.gmail.com>
        <43e44c4b-37d6-9734-b323-5b432ef27d52@thelounge.net>
        <CAC6SzHKWeLMSn1Z3W0KyBaUw+5MLmnMxLbh130gxM071t8VeFw@mail.gmail.com>
        <fc31c172-f988-32a4-c9b2-93bc7f3bfc90@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fc31c172-f988-32a4-c9b2-93bc7f3bfc90@thelounge.net>
Sender: linux-raid-owner@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>
Cc: d tbsky <tbskyd@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 13 Apr 2017 11:47:29 +0200
Reindl Harald <h.reindl@thelounge.net> wrote:

> and?
> 
> you said it is at 200000
> i showed you how to reduce it to 50000 or whatever you want

The point is that this should automatically adjust between 1000 and 200000 (on
default settings) according to other IO in the system. But since April 2015
this automatic tuning got broken and has worsened significantly for some
scenarios. The solution should be not that "well you're SOL and now always
have to hand-tune it", but to keep reporting your experience and try out the
proposed fixes so the prior automated adjustment is reimplemented, or baring
that, to revert the behavior change on your systems (already tried that just
now on my kernel build, it still reverts cleanly).

-- 
With respect,
Roman
