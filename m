From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
Subject: Re: Antw: Re: nested block devices (partitioned RAID with
 LVM): where Linux sucks ;-)
Date: Thu, 30 Jun 2011 15:46:55 +0200
Message-ID: <4E0C9A6F020000A100006505@gwsmtp1.uni-regensburg.de>
References: <4E0AED02020000A100006458@gwsmtp1.uni-regensburg.de>
 <4E0B3A2A.3050906@turmel.org>
 <4E0C5DAF020000A1000064C9@gwsmtp1.uni-regensburg.de>
 <4E0C73C4.3090307@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E0C73C4.3090307@turmel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: neilb@suse.de, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>> Phil Turmel <philip@turmel.org> schrieb am 30.06.2011 um 15:01 in Nachricht
<4E0C73C4.3090307@turmel.org>:

Hi Phil,

I'll shorten the reply a bit, as most software will find the pervious thread, I guess...

> Hi Ulrich,
> 
> [added linux-raid back to the CC]
> 
> On 06/30/2011 05:27 AM, Ulrich Windl wrote:
>>>>> Phil Turmel <philip@turmel.org> schrieb am 29.06.2011 um 16:43 in Nachricht
> > <4E0B3A2A.3050906@turmel.org>:
[...]
> >> The man-page for lvm.conf describes how to filter devices to consider, 
> >> including a setting called "md_component_detection".  Did you read about 
> >> this?
> > 
> > Yes, but that would require a VERY specific (and long) filter list.
> 
> md_component_detection should have been the only setting you needed.  LVM 
> does accept regular expressions, though, so you can give patterns of 
> acceptable devices instead of a long list.

I actually missed that. It will probably help until I have converted the RAIDs to use a newer superblock-format.

> 
> [...]
> 
> > Hmmm: My manual page says:
> >        -e, --metadata=
> >               Declare the style of RAID metadata (superblock) to be used.  
> The
> >               default is 0.90 for --create, and to guess for other 
> operations.
> >               The  default can be overridden by setting the metadata value 
> for
> >               the CREATE keyword in mdadm.conf.
> > 
> >               Options are:
> > 
> >               0, 0.90, default
> >                      Use the original 0.90  format  superblock.   This  
> format
> >                      limits  arrays  to 28 component devices and limits 
> compo-
> >                      nent devices of levels 1 and greater to 2 terabytes.
> > 
> >               1, 1.0, 1.1, 1.2
> >                      Use the new version-1 format superblock.   This  has  
> few
> >                      restrictions.    The  different  sub-versions  store  
> the
> >                      superblock at different locations on the  device,  
> either
> >                      at  the  end (for 1.0), at the start (for 1.1) or 4K 
> from
> >                      the start (for 1.2).
> 
> The superblock is part of the metadata, but not all of it.  There's also 
> space for a write-intent bitmap, and mdadm then aligns to either the chunk 
> size, or 1MB, or some combination depending on version.  The key is the data 
> offset, not the precise placement of the superblock.  If data offset == 0, 
> misidentification is possible.

OK, I was confused by the manual page. Actually getting from  0 to 100 with mdadm isn't easy.


> 
> Run 'mdadm --examine' against test devices with various metadata versions 
> and it'll be more clear.
> 
> [...]
> 
> > Yes, I'd wish to have time for active software development. For legal 
> support reasons I must use what Novell provides.

This is just to explain why I'm not using the latest version. Unless I've inspected the latest version (which I have no time for the moment (my servers cannot conect to the Internet)), it is still possible that some problem is still there. May aoplogies to those I've bored.


> 
> Then asking on these lists is pointless.  If you'd found a real bug that 
[...]

(The rest was jsut to explain why I cannot simple install the software I'd like to try out. No advertising or the inverse was ever intended)

Regards,
Ulrich


