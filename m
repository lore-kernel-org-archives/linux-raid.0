From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 04/21] devtmpfs: refactor devtmpfsd()
Date: Sun, 26 Jul 2020 10:21:18 +0200
Message-ID: <20200726082118.GA17726@lst.de>
References: <20200726071356.287160-1-hch@lst.de> <20200726071356.287160-5-hch@lst.de> <20200726074306.GA444745@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200726074306.GA444745@kroah.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Jul 26, 2020 at 09:43:06AM +0200, Greg Kroah-Hartman wrote:
> On Sun, Jul 26, 2020 at 09:13:39AM +0200, Christoph Hellwig wrote:
> > Split the main worker loop into a separate function.  This allows
> > devtmpfsd itself and devtmpfsd_setup to be marked __init, which will
> > allows us to call __init routines for the setup work.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  drivers/base/devtmpfs.c | 47 +++++++++++++++++++++++------------------
> >  1 file changed, 26 insertions(+), 21 deletions(-)
> 
> Nice cleanup, thanks for doing this:

This was actualy Als idea, I should have probably mentioned that.
