From: Song Liu <song@kernel.org>
Subject: Re: [PATCH 01/16] init: remove the bstat helper
Date: Tue, 7 Jul 2020 09:54:30 -0700
Message-ID: <CAPhsuW6CvKMPEuUEFfZhxyyU2ke9oiYOuCwkM+NM2=bo_o_MFw@mail.gmail.com>
References: <20200615125323.930983-1-hch@lst.de> <20200615125323.930983-2-hch@lst.de>
 <CAPhsuW6chy6uMpow3L1WvBW8xCsUYw4SbLHQQXcANqBVcqoULg@mail.gmail.com> <20200707103439.GA2812@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200707103439.GA2812@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: open list <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid <linux-raid@vger.kernel.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jul 7, 2020 at 3:34 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Thu, Jul 02, 2020 at 04:25:41PM -0700, Song Liu wrote:
> > Hi Christoph,
> >
> > On Mon, Jun 15, 2020 at 5:53 AM Christoph Hellwig <hch@lst.de> wrote:
> > >
> > > The only caller of the bstat function becomes cleaner and simpler whe=
n
> > > open coding the function.
> > >
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> >
> > Thanks for the set. md parts of the set look good to me.
> >
> > How should we route this set, as it touches multiple subsystems?
>
> Good question as there is no really applicable tree.  One option
> would the vfs tree as it touche=D1=95 some VFS stuff, and the follow on
> series that depends on it is all about VFS bits.  Alternatively I
> could set up a tree just for these bits.  The important bit is that
> it doesn't go into the -mm tree as the usual catchall, as I have
> more stuff that depends on it and requires a git tree.

Would this official mm tree work?

T:      git git://github.com/hnaz/linux-mm.git

If not, I am OK with either vfs tree or a dedicated tree.

Thanks,
Song
