From: Jurriaan <thunder7@xs4all.nl>
Subject: Re: new superblock and raid10 support in mdadm
Date: Tue, 14 Sep 2004 08:40:51 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040914064051.GA28661@middle.of.nowhere>
References: <1095088590.3713.4.camel@rich> <16710.17573.491674.378912@cse.unsw.edu.au>
Reply-To: Jurriaan <thunder7@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16710.17573.491674.378912@cse.unsw.edu.au>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Neil Brown <neilb@cse.unsw.edu.au>
Date: Tue, Sep 14, 2004 at 11:08:53AM +1000
> A new format is being supported because the old format has problems.
> One is that it cannot work with devices larger than 2 Gigabytes (and I
> have had a request from someone who wanted to include such a device in
> an MD array).

I presume you mean terabyte, but I'm not sure you don't mean petabyte or
something else very large?

> The raid10 module is in 2.4.9-rc2 and will be in 2.4.9 when it gets
> released. 

2.6.9 I presume?

> /*
>  * RAID10 provides a combination of RAID0 and RAID1 functionality.
>  * The layout of data is defined by
>  *    chunk_size
>  *    raid_disks
>  *    near_copies (stored in low byte of layout)
>  *    far_copies (stored in second byte of layout)
>  *
>  * The data to be stored is divided into chunks using chunksize.
>  * Each device is divided into far_copies sections.
>  * In each section, chunks are laid out in a style similar to raid0, but
>  * near_copies copies of each chunk is stored (each on a different drive).
>  * The starting device for each section is offset near_copies from the starting
>  * device of the previous section.
>  * Thus there are (near_copies*far_copies) of each chunk, and each is on a different
>  * drive.
>  * near_copies and far_copies must be at least one, and there product is at most

----------------------------------------------------------their

>  * raid_disks.
>  */

Good luck,
Jurriaan
-- 
If you hear muffled screams, consider it a request for beam out.
	Tom Paris in Voyager
Debian (Unstable) GNU/Linux 2.6.9-rc1-mm4 2x6209 bogomips load 0.14
