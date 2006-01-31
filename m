From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Exporting which partitions to md-configure
Date: Mon, 30 Jan 2006 17:45:59 -0800
Message-ID: <43DEC157.1000002@zytor.com>
References: <43DEB4B8.5040607@zytor.com> <17374.47368.715991.422607@cse.unsw.edu.au> <859CB9D0-A1D3-4931-9D9F-96153D0F3E1B@mac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <859CB9D0-A1D3-4931-9D9F-96153D0F3E1B@mac.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Neil Brown <neilb@suse.de>, klibc list <klibc@zytor.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Kyle Moffett wrote:
> 
> Well, for an MSDOS partition table, you would look for '253', for a  Mac 
> partition table you could look for something like 'Linux_RAID' or  
> similar (just arbitrarily define some name beginning with the Linux_  
> prefix), etc.  This means that the partition table type would need to  
> be exposed as well (I don't know if it is already).
> 

It's not, but perhaps exporting "format" and "type" as distinct 
attributes is the way to go.  The policy for which partitions to 
consider would live entirely in kinit that way.

type would be format-specific; in EFI it's a UUID.

This, of course, is a bigger change, but it just might be worth it.

	-hpa
