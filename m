From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: bcache: BUG in fuzz testing without devices
Date: Fri, 5 Apr 2013 14:21:10 -0700
Message-ID: <20130405212110.GD15749@google.com>
References: <515B056E.6010002@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <515B056E.6010002-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-raid.ids

On Tue, Apr 02, 2013 at 12:21:02PM -0400, Sasha Levin wrote:
> Hi all,
> 
> It seems that trying to fuzz bcache without any devices triggers a BUG:
> 
> That BUG looks very intentional there, any reason for adding it instead of exiting
> if there aren't any devices?

The fuzz tester is meant to stress test some of the btree code - it's a
purely in memory test. But it looks like it's rotted - thanks for the
bug report, I'll disable it for now.
