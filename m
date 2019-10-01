From: Song Liu <liu.song.a23@gmail.com>
Subject: Re: [PATCH v3 0/3] Fix typo in RWH_WRITE_LIFE_NOT_SET constant name
Date: Tue, 1 Oct 2019 16:12:53 -0700
Message-ID: <CAPhsuW5CvJNRP5OO_M6XVd9q0x-CH9eADWR5oqdJP20eFScCFw@mail.gmail.com>
References: <cover.1568994791.git.esyr@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1568994791.git.esyr@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eugene Syromiatnikov <esyr@redhat.com>
Cc: open list <linux-kernel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@kernel.org>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Sep 20, 2019 at 8:58 AM Eugene Syromiatnikov <esyr@redhat.com> wrote:
>
> Hello.
>
> This is a small fix of a typo (or, more specifically, some remnant of
> the old patch version spelling) in RWH_WRITE_LIFE_NOT_SET constant,
> which is named as RWF_WRITE_LIFE_NOT_SET currently.  Since the name
> with "H" is used in man page and everywhere else, it's probably worth
> to make the name used in the fcntl.h UAPI header in line with it.
> The two follow-up patches update usage sites of this constant in kernel
> to use the new spelling.
>
> The old name is retained as it is part of UAPI now.
>
> Changes since v2[1]:
>  * Updated RWF_WRITE_LIFE_NOT_SET constant usage
>    in drivers/md/raid5-ppl.c:ppl_init_log().
>
> Changes since v1[2]:
>  * Changed format of the commit ID in the commit message of the first patch.
>  * Removed bogus Signed-off-by that snuck into the resend of the series.

Applied to md-next.

Thanks,
Song
