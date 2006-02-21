From: Neil Brown <neilb@suse.de>
Subject: Re: Bigendian issue with mdadm
Date: Tue, 21 Feb 2006 17:38:39 +1100
Message-ID: <17402.46447.61347.230505@cse.unsw.edu.au>
References: <fd8d0180602201338t5f728fem@mail.gmail.com>
	<17402.21590.564710.372935@cse.unsw.edu.au>
	<20060221061755.GA24192@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Luca Berra on Tuesday February 21
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday February 21, bluca@comedia.it wrote:
> On Tue, Feb 21, 2006 at 10:44:22AM +1100, Neil Brown wrote:
> >On Monday February 20, francois.barre@gmail.com wrote:
> >> Hi All,
> >> 
> >> Please, Help !
> >> 
> >> I've created a raid5 array on a x86 platform, and now wish to use it
> >> on a mac mini (g4 based). But the problem is : the first is
> >> little-endian, the second big-endian...
> >> And it seams like md superblock disk format is hostendian, so how
> >> should I say mdadm to use a endianness ?
> >> 
> >
> >Read the man page several times?
> >
> >Look for "--update=byteorder"
> >
> >You need mdadm-2.0 or later.
> >
> besides IIRC version 1 super block is always little-endan.
> 

True.  v1 is little-endian, not host-endian so this issue won't appear
if using v1 metadata.  However the default is 0.90, and I'm still
finding occasional bugs with the v1 code, so I'm not likely to change
the default soon any time soon... probably not for 1 year after I'm as
confident of v1 code as of v0.90.

NeilBrown
