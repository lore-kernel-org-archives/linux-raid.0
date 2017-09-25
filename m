From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Need Help for Raid Recovery
Date: Mon, 25 Sep 2017 18:57:39 +0100
Message-ID: <59C94393.8010405@youngman.org.uk>
References: <ccba6492-26b7-c084-aa1e-6d69c7f48785@nus.edu.sg>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ccba6492-26b7-c084-aa1e-6d69c7f48785@nus.edu.sg>
Sender: linux-raid-owner@vger.kernel.org
To: Xuesong LU <disluxs@nus.edu.sg>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 25/09/17 08:53, Xuesong LU wrote:
> mdadm --examine /dev/sd[g-p] prints raid partition information for
> sd[h,i,j,l,m,n]. No superblock detected on sd[g,k,o,p].
> 
> mdadm --examine /dev/sd[g-p]1 prints raid partition information for
> sd[h,i,j,l,m,n]1. The event counts are the same. It also prints 'No
> superblock detected' for sdg1, and 'no such files' for sd[k,o,p]1.
> (Gone? Can still recover?)
> 
> I have UUID for md0 in the mdadm.conf file.
> 
> Is there still hope to recover my raid? Thank you!

Go to the raid wiki, and post the requested info to the list.

https://raid.wiki.kernel.org/index.php/Linux_Raid#When_Things_Go_Wrogn

Make sure you're using the latest mdadm.

This looks a little familiar to me, but so long as nothing has written
to the disk, and/or the only thing that has been damaged is the
superblocks, this looks rather hopeful.

Bear in mind, though, if the superblocks ARE gone, then it's going to be
a hassle to get it back. A fair bit of trial and error is on the cards
(read up on overlays). But as long as nothing has actually stomped on
the data itself, you should be able to get it back.

Do an "fdisk -l" on k, o, p. I remember a problem a while back when
something stamped on the partition table ...

Cheers,
Wol
