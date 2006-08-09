From: Luca Berra <bluca@comedia.it>
Subject: Re: resize new raid problem
Date: Wed, 9 Aug 2006 12:11:03 +0200
Message-ID: <20060809101103.GF22136@percy.comedia.it>
References: <eIi4Rs4Pcs@buratino.peterlink.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <eIi4Rs4Pcs@buratino.peterlink.ru>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Aug 09, 2006 at 01:55:56PM +0400, Serge Torop wrote:
>I need to install softw. RAID1 to working RedHat EL4.
>
>I used "rescue mode" for creating RAID arrays.
...
>resize2fs /dev/md2 and see a error messge:
>
>resize2fs 1.39
>/resize2fs: relocation error: - /resize2fs: undefined symbol: ext2fs_open2
>
>Can I resolve this problem (resize2fs bug?)?
>(may be using mdadm?)
>
since you bought a commercial product from redhat you might be better
open a support call to them.
if the resize2fs binary you are using comes from EL4, that is.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
