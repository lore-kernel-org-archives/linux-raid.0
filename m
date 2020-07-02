From: Song Liu <song@kernel.org>
Subject: Re: [PATCH 01/16] init: remove the bstat helper
Date: Thu, 2 Jul 2020 16:25:41 -0700
Message-ID: <CAPhsuW6chy6uMpow3L1WvBW8xCsUYw4SbLHQQXcANqBVcqoULg@mail.gmail.com>
References: <20200615125323.930983-1-hch@lst.de> <20200615125323.930983-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200615125323.930983-2-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: open list <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid <linux-raid@vger.kernel.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-raid.ids

Hi Christoph,

On Mon, Jun 15, 2020 at 5:53 AM Christoph Hellwig <hch@lst.de> wrote:
>
> The only caller of the bstat function becomes cleaner and simpler when
> open coding the function.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thanks for the set. md parts of the set look good to me.

How should we route this set, as it touches multiple subsystems?

Thanks,
Song
