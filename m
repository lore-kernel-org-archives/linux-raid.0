From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 008 of 8] md/bitmap: Change md/bitmap file handling to
 use bmap to file blocks.
Date: Sat, 13 May 2006 08:42:08 -0700
Message-ID: <20060513084208.0857ff52.akpm@osdl.org>
References: <20060512160121.7872.patches@notabene>
	<1060512060809.8099@suse.de>
	<20060512104750.0f5cb10a.akpm@osdl.org>
	<17509.22160.118149.49714@cse.unsw.edu.au>
	<20060512235934.4f609019.akpm@osdl.org>
	<4465FB5C.6070808@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932455AbWEMPpP@vger.kernel.org>
In-Reply-To: <4465FB5C.6070808@steeleye.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Paul Clements <paul.clements@steeleye.com> wrote:
>
> Andrew Morton wrote:
> 
> > The loss of pagecache coherency seems sad.  I assume there's never a
> > requirement for userspace to read this file.
> 
> Actually, there is. mdadm reads the bitmap file, so that would be 
> broken. Also, it's just useful for a user to be able to read the bitmap 
> (od -x, or similar) to figure out approximately how much more he's got 
> to resync to get an array in-sync. Other than reading the bitmap file, I 
> don't know of any way to determine that.

Read it with O_DIRECT :(
