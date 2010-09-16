From: Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] md: do not use ++ in rcu_dereference() argument
Date: Thu, 16 Sep 2010 14:54:29 +0200
Message-ID: <4C921385.2080205@redhat.com>
References: <1283711539-7123-1-git-send-email-segooon@gmail.com>	<20100905190139.GA3163@merkur.ravnborg.org>	<20100905192335.GA8140@albatros>	<20100905203908.GA3228@merkur.ravnborg.org> <20100906152931.1d4a1d07@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100906152931.1d4a1d07@notabene>
Sender: linux-kernel-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, Kulikov Vasiliy <segooon@gmail.com>, kernel-janitors@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

  On 09/06/2010 08:29 AM, Neil Brown wrote:
> I've taken the opportunity to substantially re-write that code.
>
>

It's better to have two patches, one a backportable one liner that fixes 
the bug, the other, on top, that cleans up the code but has no sematic 
changes.

This makes it substantially easier to review.  When considering the 
first patch you see the change plainly.  When reviewing the second patch 
you make sure no semantic changes were made at all.

-- 
error compiling committee.c: too many arguments to function
