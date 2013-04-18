From: Dan Williams <djbw@fb.com>
Subject: Re: [PATCH] raid5: add support for rmw writes in raid6
Date: Thu, 18 Apr 2013 11:40:38 -0700
Message-ID: <CAA9_cmdDEfN+FfWrcEYfZHnq1oTOxHs6sD3ksGFR6ycwWF+jxw@mail.gmail.com>
References: <20130418005609.6782.15041.stgit@dev279.prn2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130418005609.6782.15041.stgit@dev279.prn2.facebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, Kumar Sundararajan <kumar@fb.com>
List-Id: linux-raid.ids

On Wed, Apr 17, 2013 at 5:56 PM, Dan Williams <djbw@fb.com> wrote:
> Here are some numbers from Kumar's testing with a 12 disk array:
>
>                                      with rmw   rcw only
> 4K random write                    887.0 KB/s  94.4 KB/s

copy pasta error, should be 493KB/s for rcw only...
