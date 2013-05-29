From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] md: bcache: io.c: fix a potential NULL pointer
 dereference
Date: Tue, 28 May 2013 17:20:41 -0700
Message-ID: <20130529002041.GC2291@google.com>
References: <1369726275-5424-1-git-send-email-gmate.amit@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1369726275-5424-1-git-send-email-gmate.amit-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kumar Amit Mehta <gmate.amit-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: neilb-l3A5Bk7waGM@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

On Tue, May 28, 2013 at 12:31:15AM -0700, Kumar Amit Mehta wrote:
> bio_alloc_bioset returns NULL on failure. This fix adds a missing check
> for potential NULL pointer dereferencing.

Whoops, that's definitely a bug. Thanks, applied.

How'd you find it?
