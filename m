From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: A few remaining questions about installing to RAID-10
Date: Sat, 3 Oct 2009 18:55:34 +0200
Message-ID: <20091003165534.GA19189@rap.rap.dk>
References: <babafd2f0910020754i4818043aw3d4a15e91eec9eb8@mail.gmail.com> <275143.15844.qm@web38804.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <275143.15844.qm@web38804.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: adfas asd <chimera_god@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Oct 03, 2009 at 07:12:55AM -0700, adfas asd wrote:
> --- On Fri, 10/2/09, Ben DJ <bendj095124367913213465@gmail.com> wrote:
> > On Fri, Oct 2, 2009 at 5:30 AM, adfas asd <chimera_god@yahoo.com>
> > wrote:
> > 
> What I know is that 'offset' will boot and fail over.  I don't know if 'far' will.  I also know that .90 will boot and fail over.  I don't know whether 1.x will.  When building the array I tried to use 1.2 (as I thought it was newest/best) but there was a bitch at the beginning of boot and it wouldn't boot (for other reasons) so I reverted to .90.  When I do it again I will likely use 1.0, given what I've recently learned here.

I am surprised that raid10,o2 will fail over. But maybe your bootloader
understands raidi10,o2. My understanding is that on the second copy of
the disk, blocks are flipped, and thus unreadable as a simple boot
device.

> I am still confused about the benefits of far vs offset.  Keld (the developer) says that although offset is newer, it's not necessarily better than far, only more compatible.  I have not found any rigorous performance comparisons of far vs offset.

I am not the developer of far, only the designer, and then I did a small patch.

There are a number of performance comparisons of far and offset at
http://linux-raid.osdl.org/index.php/Performance

If you are employing a filesystem, then be sure to look at tests
that also do so, to take advantage of the effects of the file system
elevator algorithms and buffering.

Best regards
keld
