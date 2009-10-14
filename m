From: Antonio Perez <ap23563m@gmx.com>
Subject: Re: About seting up Raid5 on a four disk box.
Date: Wed, 14 Oct 2009 08:55:38 -0400
Message-ID: <hb4hob$cg8$2@ger.gmane.org>
References: <hb1udb$6t1$1@ger.gmane.org> <20091013152304.GA19668@cthulhu.home.robinhill.me.uk> <hb3vij$j47$1@ger.gmane.org> <20091014085606.GA13917@cthulhu.home.robinhill.me.uk>
Reply-To: ap23563m@gmx.com
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Robin Hill wrote:

> On Wed Oct 14, 2009 at 03:45:21AM -0400, Antonio Perez wrote:
> 
>> Robin Hill wrote:
[snip]
 
>> Is this assumption correct?
>> 
> Yes - anything that falls within the blocks covered by the array will
> get replicated, so "Area 2" will automatically get taken care of (you'll
> have to make sure the RAID metadata version is chosen correctly so as
> not to conflict though - 1.1/1.2 metadata may overlap with the area used
> by grub here).

Thanks. Yes, I am aware of the conflicts between metadata 1.x and grub. 
 
> As for "Area 1" - from what you've written (and reading the grub
> internals documentation), I can only assume you're referring to the
> stage1.5 bootloader (unless you're using grub2?).  This can live on the
> file system (I don't see anything obvious in the documentation about how
> you set where it goes - the documentation seems to suggest that the file
> system is the default), so so there may well be no need to do anything
> about this (other than the MBR itself).

I do use Grub2, but both gub-legacy and grub2 now do use the disk sectors 
following the MBR to embed the boot code.

Looking at:	http://thestarman.pcministry.com/asm/mbr/GRUB.htm

the pointer at 0x7C44 (disk offset 0x0044) is the sector which is to be 
loaded next. It is usually 0x0001, which means simply the next sector.

I'll look at the grub-source later, but I am pretty sure that is the case.

>> >> 2.- Is there a recomended way to trigger the said copy of question 2?
>> >> Where should a call to copy the MBR should be placed? On update-grub?
>> 
>> > I always just rerun the grub install for each disk manually (see
>>http://lists.us.dell.com/pipermail/linux-poweredge/2003-July/008898.html
>> > for example).
>> 
>> That's the usual procedure on a first install, correct.
>> 
> It's what I do every update - it's a quick enough process, and grub
> updates aren't very common (all the development's on grub2 now).

Thanks, Robin

-- 
Antonio Perez

