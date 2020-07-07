From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/16] init: remove the bstat helper
Date: Tue, 7 Jul 2020 12:34:39 +0200
Message-ID: <20200707103439.GA2812@lst.de>
References: <20200615125323.930983-1-hch@lst.de> <20200615125323.930983-2-hch@lst.de> <CAPhsuW6chy6uMpow3L1WvBW8xCsUYw4SbLHQQXcANqBVcqoULg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPhsuW6chy6uMpow3L1WvBW8xCsUYw4SbLHQQXcANqBVcqoULg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Song Liu <song@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, open list <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid <linux-raid@vger.kernel.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Jul 02, 2020 at 04:25:41PM -0700, Song Liu wrote:
> Hi Christoph,
> 
> On Mon, Jun 15, 2020 at 5:53 AM Christoph Hellwig <hch@lst.de> wrote:
> >
> > The only caller of the bstat function becomes cleaner and simpler when
> > open coding the function.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Thanks for the set. md parts of the set look good to me.
> 
> How should we route this set, as it touches multiple subsystems?

Good question as there is no really applicable tree.  One option
would the vfs tree as it toucheѕ some VFS stuff, and the follow on
series that depends on it is all about VFS bits.  Alternatively I
could set up a tree just for these bits.  The important bit is that
it doesn't go into the -mm tree as the usual catchall, as I have
more stuff that depends on it and requires a git tree.
