From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Exporting which partitions to md-configure
Date: Mon, 30 Jan 2006 20:43:01 -0500
Message-ID: <859CB9D0-A1D3-4931-9D9F-96153D0F3E1B@mac.com>
References: <43DEB4B8.5040607@zytor.com> <17374.47368.715991.422607@cse.unsw.edu.au>
Mime-Version: 1.0 (Apple Message framework v746.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17374.47368.715991.422607@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, klibc list <klibc@zytor.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Jan 30, 2006, at 20:10, Neil Brown wrote:
> On Monday January 30, hpa@zytor.com wrote:
>> Any feeling how best to do that?  My current thinking is to export  
>> a "flags" entry in addition to the current ones, presumably based  
>> on "struct parsed_partitions->parts[].flags" fs/partitions/ 
>> check.h), which seems to be what causes md_autodetect_dev() to be  
>> called.
>
> I think I would prefer a 'type' attribute in each partition that  
> records the 'type' from the partition table.  This might be more  
> generally useful than just for md.  Then your userspace code would  
> have to look for '253' and use just those partitions.

Well, for an MSDOS partition table, you would look for '253', for a  
Mac partition table you could look for something like 'Linux_RAID' or  
similar (just arbitrarily define some name beginning with the Linux_  
prefix), etc.  This means that the partition table type would need to  
be exposed as well (I don't know if it is already).

Cheers,
Kyle Moffett

--
I lost interest in "blade servers" when I found they didn't throw  
knives at people who weren't supposed to be in your machine room.
   -- Anthony de Boer


