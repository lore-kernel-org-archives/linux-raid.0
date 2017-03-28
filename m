From: Jiri Kosina <jikos@kernel.org>
Subject: Re: [PATCH] Fix dead URLs to ftp.kernel.org
Date: Tue, 28 Mar 2017 16:20:34 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1703281620140.31814@cbobk.fhfr.pm>
References: <CAEjAshqR0Nhp4Wkmkg_HrswsiuUb3rYJ=TOUSBSvoUT3FSWTjg@mail.gmail.com> <20170327124406.6910-1-sj38.park@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <autofs-owner@vger.kernel.org>
In-Reply-To: <20170327124406.6910-1-sj38.park@gmail.com>
Sender: autofs-owner@vger.kernel.org
To: SeongJae Park <sj38.park@gmail.com>
Cc: rml@tech9.net, axboe@fb.com, shli@kernel.org, raven@themaw.net, yamada.masahito@socionext.com, mmarek@suse.com, linux-raid@vger.kernel.org, autofs@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 27 Mar 2017, SeongJae Park wrote:

> URLs to ftp.kernel.org are still exist though the service is closed [0].
> This commit fixes the URLs to use www.kernel.org instead.
> 
> [0] https://www.kernel.org/shutting-down-ftp-services.html
> 
> Signed-off-by: SeongJae Park <sj38.park@gmail.com>

I've applied this to trivial.git#for-next.

-- 
Jiri Kosina
SUSE Labs

--
To unsubscribe from this list: send the line "unsubscribe autofs" in
