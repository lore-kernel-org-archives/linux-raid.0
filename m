From: "Francois Barre" <francois.barre@gmail.com>
Subject: Re: Bigendian issue with mdadm
Date: Tue, 21 Feb 2006 09:37:33 +0100
Message-ID: <fd8d0180602210037q6537edcdu@mail.gmail.com>
References: <fd8d0180602201338t5f728fem@mail.gmail.com>
	 <17402.21590.564710.372935@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17402.21590.564710.372935@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2006/2/21, Neil Brown <neilb@suse.de>:
> On Monday February 20, francois.barre@gmail.com wrote:
> > Hi All,
> >
> > Please, Help !
> >
[...]
> > And it seams like md superblock disk format is hostendian, so how
> > should I say mdadm to use a endianness ?
> >
>
> Read the man page several times?
>
> Look for "--update=byteorder"
>
> You need mdadm-2.0 or later.
>
> NeilBrown
>

Ooops... You know what it is : the more you focus on a problem, the
less you can see solutions floating around...
I had mdadm-1.2 installed, and of course did not think about
upgrading... I will test this asap.
This will avoid me to code a byte reordering program... Thanks Neil !
BTW : I did not see this feature in the kernel code, and after a quick
look at mdadm source, seems to be implemented in
super0.c:super0_swap_endian(). Is there any prerequisite regarding the
kernel version for this to work ?

Thanks again Neil, I am really impressed by your patience answering
dummy questions...

Regards,
