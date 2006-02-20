From: Neil Brown <neilb@suse.de>
Subject: Re: Bigendian issue with mdadm
Date: Tue, 21 Feb 2006 10:44:22 +1100
Message-ID: <17402.21590.564710.372935@cse.unsw.edu.au>
References: <fd8d0180602201338t5f728fem@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Francois Barre on Monday February 20
Sender: linux-raid-owner@vger.kernel.org
To: Francois Barre <francois.barre@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday February 20, francois.barre@gmail.com wrote:
> Hi All,
> 
> Please, Help !
> 
> I've created a raid5 array on a x86 platform, and now wish to use it
> on a mac mini (g4 based). But the problem is : the first is
> little-endian, the second big-endian...
> And it seams like md superblock disk format is hostendian, so how
> should I say mdadm to use a endianness ?
> 

Read the man page several times?

Look for "--update=byteorder"

You need mdadm-2.0 or later.

NeilBrown
