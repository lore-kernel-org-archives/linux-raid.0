From: "Mike Black" <mblack@csi-inc.com>
Subject: Re: MD device id change
Date: Fri, 4 Apr 2003 08:20:36 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <019301c2faac$fcde9640$f6de11cc@black>
References: <Pine.LNX.4.33.0304031754490.5184-100000@worf.desy.de> <16012.45741.447317.341813@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: raid-list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Here's one I've run into Neil -- Put an already-running md on another system with the same minor #.

Can you start the new md and not have to stop the old one?

i.e.
/dev/md2 on system#1
/dev/md2 on system#2
move /dev/md2 chassis to system#2

Would this work?
mdadm --assemble --uuid=MOVED_MD2 --super-minor=2 /dev/md3

And would the array now stay as md3?

----- Original Message ----- 
From: "Neil Brown" <neilb@cse.unsw.edu.au>
To: "Alexander Kisselev" <kisselev@mail.desy.de>
Cc: "raid-list" <linux-raid@vger.kernel.org>
Sent: Thursday, April 03, 2003 5:16 PM
Subject: Re: MD device id change


> On Thursday April 3, kisselev@mail.desy.de wrote:
> > 
> >   Here is the question: is there an easy way to change RAID device ID?
> > If not, is the following sequence correct in my case (1-disk RAID linear):
> > 
> >   - stop device;
> >   - 'dd' 4k RAID superblock from /dev/sda2 at offset 292021440;
> >   - change 4-byte field at offset 11 (md_minor) to the desired number
> >     (say '5' for md5);
> >   - copy superblock back;
> >   - reboot;
> 
> Sort of, but it is much easier to get mdadm to do this.
> Get mdadm 1.2.0 and check out
>    --assemble --update=super-minor
> 
> in the documentation.
> 
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
