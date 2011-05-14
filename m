From: Louis-David Mitterrand <vindex+lists-linux-raid@apartia.org>
Subject: Re: /dev/md2 stopped after changing SAS controller
Date: Sat, 14 May 2011 16:19:27 +0200
Message-ID: <20110514141926.GA2818@apartia.fr>
References: <20110513202900.GA1926@apartia.fr>
 <20110514073347.15dae0b8@notabene.brown>
 <20110514082159.GA306@apartia.fr>
 <20110514215821.58f49455@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110514215821.58f49455@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, May 14, 2011 at 09:58:21PM +1000, NeilBrown wrote:
> 
> If the filesystem is ext3, then with the old controller you could
> resize2fs the filesystem to be several megabytes smaller - aim to over-shrink
> rather than under-shrink.  Say 2 Meg per devices, so 12Mmeg ... so maybe
> 20Meg for safety... or even double that again.
> 
> Then use mdadm to make the  array smaller (mdadm --grow --size=whatever).
> Then 'fsck -f' the filesystem to make sure it is still OK.  If you messed up
> you can still make the size bigger again with mdadm.  The 'size' is the
> per-device size, so 1/6 of the array size, but a multiple of the chunk size.
> 
> Then switch back to the new controller and assemble with --update=devicesize
> so:
>    mdadm -A /dev/md2 --update=devicesize /dev/sd[abcdefg]3
> 
> and it should all work.
> 
> If you don't have ext3, then you probably need to backup and restore - I
> don't think other filesystems support shrinking, but I could be wrong.

Thanks for your help.

Alas /dev/md2 is xfs so dump/restore it will be...

For next time, what is the prudent disk space to reserve at the end for
these greedy controllers?
