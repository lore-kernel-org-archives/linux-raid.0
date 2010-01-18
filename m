From: Luca Berra <bluca@comedia.it>
Subject: Re: How to load preexisting ntfs partitions that are on an Intel
	Matrix Raid 1 or 5 ?
Date: Mon, 18 Jan 2010 08:53:15 +0100
Message-ID: <20100118075315.GB28405@maude.comedia.it>
References: <8CC636345AA2F7E-295C-545@webmail-d049.sysops.aol.com> <8CC636C98CCAF21-295C-17C7@webmail-d049.sysops.aol.com> <20100116090848.GA21855@maude.comedia.it> <8CC64CAEA9C15A3-938C-10EBD@webmail-m048.sysops.aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8CC64CAEA9C15A3-938C-10EBD@webmail-m048.sysops.aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Jan 16, 2010 at 08:57:03AM -0500, sylarrrrrrr@aim.com wrote:
> OK So this is the mdadm mailing list, and the /dev/mapper is irrelevant 
> here, right? So ...
>
> How do I load my existing raid arrays with mdadm?

first make sure they have not been claimed by dmraid.
issuing "dmraid -an" should suffice
then just run "mdadm -As".
looking at /proc/mdstat you should see a container device (or array
using windows driver terminology) and the actual
raid volume.
under /dev/md you should also find meaningful device names and device
file for the partitions contained in the volume.

<snip>

> PS. I am not next to that machine right now, but I have 3 raid devices on 
> it and in the /dev/mapper there were about 6 or 8 devices some of which had 
> similar names and consecutive numbers e.g. xxxxxxxxxxxxx_System1 
> xxxxxxxxxxxxx_System2 xxxxxxxxxxxxx_System3 while my partition on one of 
> the raid devices was called System and was raid 1 of two disks.

please quote either above or below, it is a pain to read if you quote in
the middle.
That said, you use the term 'device' above with two differemt meanings,
and i am not quite sure of what you intend.
please elaborate on "I have 3 raid devices"
- 3 hard disks in the container (array)
- a container with three volumes

then you probably mix partition and volume
xxxxxxxxxxxxx_System1 is the first partition on volume System of Array
xxxxxxxxxxxxx (unfortunately arrays dont have meaningful names)
xxxxxxxxxxxxx_System2 is the second partition ....
and so on


-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
