From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Exporting which partitions to md-configure
Date: Mon, 30 Jan 2006 17:42:45 -0800
Message-ID: <43DEC095.2090507@zytor.com>
References: <43DEB4B8.5040607@zytor.com> <17374.47368.715991.422607@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17374.47368.715991.422607@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: klibc list <klibc@zytor.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Monday January 30, hpa@zytor.com wrote:
> 
>>Any feeling how best to do that?  My current thinking is to export a 
>>"flags" entry in addition to the current ones, presumably based on 
>>"struct parsed_partitions->parts[].flags" (fs/partitions/check.h), which 
>>seems to be what causes md_autodetect_dev() to be called.
> 
> I think I would prefer a 'type' attribute in each partition that
> records the 'type' from the partition table.  This might be more
> generally useful than just for md.
> Then your userspace code would have to look for '253' and use just
> those partitions.
> 

What about non-DOS partitions?

	-hpa
