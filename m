From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/16] init: remove the bstat helper
Date: Wed, 8 Jul 2020 08:38:45 +0200
Message-ID: <20200708063845.GA5468@lst.de>
References: <20200615125323.930983-1-hch@lst.de> <20200615125323.930983-2-hch@lst.de> <CAPhsuW6chy6uMpow3L1WvBW8xCsUYw4SbLHQQXcANqBVcqoULg@mail.gmail.com> <20200707103439.GA2812@lst.de> <CAPhsuW6CvKMPEuUEFfZhxyyU2ke9oiYOuCwkM+NM2=bo_o_MFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPhsuW6CvKMPEuUEFfZhxyyU2ke9oiYOuCwkM+NM2=bo_o_MFw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Song Liu <song@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, open list <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid <linux-raid@vger.kernel.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jul 07, 2020 at 09:54:30AM -0700, Song Liu wrote:
> Would this official mm tree work?
> 
> T:      git git://github.com/hnaz/linux-mm.git
> 
> If not, I am OK with either vfs tree or a dedicated tree.

That is a constantly rebased tree, so I don't think it helps.
