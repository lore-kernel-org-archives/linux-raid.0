From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm --size and --update=uuid etc options...
Date: Mon, 5 Dec 2005 22:46:46 +1100
Message-ID: <17300.10406.203538.561947@cse.unsw.edu.au>
References: <43941B51.5090601@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Michael Tokarev on Monday December 5
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday December 5, mjt@tls.msk.ru wrote:
> I found it's quite difficult, after resizing underlying
> partitions, to compute the new size for
>   mdadm /dev/mdX -G --size=xyz
> command, because of the way how it finds the superblock
> offset.  So, the question is -- is it possible to make
> the argument of --size to be optional, and let mdadm to
> compute the size automatically, just like resize2fs does
> now?  Or, maybe, to keep backward compatibility for
> those people who used --size z (as opposed to --size=z),
> to recognize `0' as special size, to mean "whole partition"
> or "max size".  The latter is probably the best, i think.

 From the man page:
OPTIONS
....
For create or build:
....
       -z, --size=
       ....

              This value can be set with --grow for RAID level 1/4/5/6. If the
              array was created with a size smaller than the currently  active
              drives,  the extra space can be accessed using --grow.  The size
              can be given as max which means to choose the largest size  that
              fits on all current drives.

(The word 'max' is in bold).

So maybe it should be "For create, build, or grow", but it seems to be
there:
  mdadm --grow /dev/mdX --size=max
does the trick.
That text in the man page was added for 1.12.0.

> 
> The same is for newly appeared --update=uuid:xyz: I'd let
> mdadm to choose an uuid just like it does for newly create
> array, if the uuid argument isn't specified, like:
>   --update=uuid:1234 --- use uuid=1234
>   --update=uuid      --- choose random uid

Again from the man page:
OPTIONS
....
For assemble:
....
       -U, --update=
              Update the superblock on each device while assembling the array.
              The  argument  given  to  this flag can be one of sparc2.2, sum-
              maries, uuid, resync, byteorder, or super-minor.

       ....

              The uuid option will change the uuid of the array.  If a UUID is
              given with the "--uuid" option that UUID will be used as  a  new
              UUID  and  with  NOT be used to help identify the devices in the
              array.  If no "--uuid" is given, a random uuid is chosen.

So I guess it already does what you want.

Any suggestion on how to make the man page clear will be welcome.

Thanks,
NeilBrown

> 
> Does it all look ok?
> 
> /mjt, who goes to produce some patches...
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
