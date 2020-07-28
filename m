From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 04/23] devtmpfs: refactor devtmpfsd()
Date: Tue, 28 Jul 2020 18:59:13 +0200
Message-ID: <20200728165913.GB42656@kroah.com>
References: <20200728163416.556521-1-hch@lst.de>
 <20200728163416.556521-5-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200728163416.556521-5-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jul 28, 2020 at 06:33:57PM +0200, Christoph Hellwig wrote:
> Split the main worker loop into a separate function.  This allows
> devtmpfsd_setup to be marked __init, which will allows us to call
> __init routines for the setup work.  devtmpfѕ itself needs a __ref
> marker for that to work, and a comment explaining why it works.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
