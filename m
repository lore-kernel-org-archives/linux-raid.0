From: Neil Brown <neilb@suse.de>
Subject: Re: Exporting which partitions to md-configure
Date: Tue, 31 Jan 2006 12:10:32 +1100
Message-ID: <17374.47368.715991.422607@cse.unsw.edu.au>
References: <43DEB4B8.5040607@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030254AbWAaBKj@vger.kernel.org>
In-Reply-To: message from H. Peter Anvin on Monday January 30
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: klibc list <klibc@zytor.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday January 30, hpa@zytor.com wrote:
> 
> Any feeling how best to do that?  My current thinking is to export a 
> "flags" entry in addition to the current ones, presumably based on 
> "struct parsed_partitions->parts[].flags" (fs/partitions/check.h), which 
> seems to be what causes md_autodetect_dev() to be called.
> 

I think I would prefer a 'type' attribute in each partition that
records the 'type' from the partition table.  This might be more
generally useful than just for md.
Then your userspace code would have to look for '253' and use just
those partitions.

NeilBrown
