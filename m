From: Atro Tossavainen <atossava@cc.helsinki.fi>
Subject: Re: Root Drive Mirroring and LVM.
Date: Tue, 23 Mar 2004 09:27:30 +0200 (EET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200403230727.i2N7RUFg013662@kruuna.Helsinki.FI>
References: <20040204122317.K27780@forte.austin.ibm.com>
Reply-To: Atro.Tossavainen@helsinki.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040204122317.K27780@forte.austin.ibm.com> from "linas@austin.ibm.com"
 at "Feb 4, 2004 12:23:17 pm"
To: linas@austin.ibm.com
Cc: Neil Brown <neilb@cse.unsw.edu.au>, Atro.Tossavainen@helsinki.fi, linuxppc-dev@lists.linuxppc.org, linux-raid@vger.kernel.org, tas@mindspring.com
List-Id: linux-raid.ids

On Wed, 4 Feb 2004 12:23:17 -0600, linas@austin.ibm.com wrote:

> On Wed, Jan 28, 2004 at 12:42:18PM +1100, Neil Brown wrote:
>
> > I personally think auto-detect is the wrong approach and have no
> > desire to extend it to other partition types (I cannot remove it from
> > DOS partitions as that breaks back-compatability).
> > Just use "md=..."
> 
> What's wrong with autodetect?  Its saved my butt a number of times.
> 
> My recurring nightmare is involves a failed ide controller.  If the 
> failed controller is on the motherboard, then plugging in a store-bought
> ide controller causes the BIOS to "randomly" renumber to hard drives.
> (yes, sorry this is a PC issue, but I would guess that similar issues 
> lurk in open firmware, etc). 

Indeed.  Speaking for myself only, the whole issue has only come about
because somewhere after 2.4.20, the handling of Promise add-on IDE
controllers was changed so that where the Promise hard drives on the
Apple Xserve were previously /dev/hde to /dev/hdh and the "mainboard"
IDE (which only handles the CD-ROM) was /dev/hda to /dev/hdd, their
internal order is now reversed, and for some reason I am unable to get
the metadevice to work after the change (so am effectively unable to
update my kernel as root is on md).

-- 
Atro Tossavainen (Mr.)               / The Institute of Biotechnology at
Systems Analyst, Techno-Amish &     / the University of Helsinki, Finland,
+358-9-19158939  UNIX Dinosaur     / employs me, but my opinions are my own.
< URL : http : / / www . helsinki . fi / %7E atossava / > NO FILE ATTACHMENTS
