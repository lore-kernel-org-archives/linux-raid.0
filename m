From: maarten <maarten@ultratux.net>
Subject: Re: combining two raid systems
Date: Fri, 14 Jan 2005 04:09:02 +0100
Message-ID: <200501140409.02405.maarten@ultratux.net>
References: <200501132017.16910.maarten@ultratux.net> <16871.11256.955469.266210@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16871.11256.955469.266210@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday 14 January 2005 03:18, Neil Brown wrote:
> On Thursday January 13, maarten@ultratux.net wrote:

> > All md arrays are self-booting 0xFD partitions.

> > Now when I boot I get a lilo prompt, so I know the right disk is booted
> > by the BIOS.  When logged in, I see only the md devices from system two,
> > and thus the current md0 "/" drive is from system two.  Now what options
> > do I have ?
>
> This is exactly why I despise auto-detect (0xFD partitions). When it
> works, it works well, but when it doesn't it causes real problems.

Ah.  I really liked it but maybe that only stems from pre-mdadm time.
I think the howto might not reflect this, but then again it's been a while 
since I looked at it.  In this case it had me stumped for a while, indeed.

> You seem to have solved a lot of your problems based on subsequent

Yep, in fact, all of them.  The 2-hour resync time has elapsed and grub (oh 
praise) worked right off the bat this time around :-))
(Except for the intel e1000 problem but I postponed that eventually, I'm now 
using the onboard 8139too again for a while.)

> emails, but the simplest approach would be to remove the 0xFD setting
> on all partitions except those for the root filesystem.
> Once you have done that, you should be able to boot fine, though only
> the root array will be assembled of course.

Obviously, but at that point that is not a drawback, maybe even the opposite.
It depends whether you have /usr or /var on raid, but I have only data arrays.

> Then something  like
>   mdadm -E -s -c partitions

Eh, that translates to 'mdadm --examine --scan --config', right ?
(oh wait, NOW I understand what the manpage says there...!!
I interpreted 'partitions' as something else... Hum.)

> will cause mdadm to find all your arrays and report information about
> them.
> (mdadm -Ds, as you were trying, only reports assembled arrays. You
> want '-E' to find arrays make of devices that aren't currently
> assembled).
>
> Put this information into mdadm.conf and edit out the bits you don't
> want leaving something like:
>
>   DEVICES partitions
>   ARRAY /dev/md1 UUID=....
>   ARRAY /dev/md2 UUID=.....
>   etc

...And leave out the physical devices?  In a way that makes sense since [my] 
drives get mixed all the time somehow anyway, but...
So if I understand correctly, when 0xFD is not set anymore, mdadm needs this 
configfile, but if you use 0xFD partitions the file is more or less unused ? 
I noted that a lot of the modern linux distribs don't even create it...

> Then
>    mdadm -As
>
> will assemble the rest of your arrays.

Oh, nice.  Didn't know that.

> You also wondered about "personality" numbers.
> A "personality" corresponds to a module that handles 1 or more raid
> levels.
> Personality 3 handles raid1
> Personality 4 handles raid5 and raid4

Yes, I later realized that the md scanning happens twice.  At first the kernel 
scans devices, groups them, prepares to assemble and start them and 
_only_then_ realizes it has no raid-X support available.  So then the 
bootprocess continues, goes on to loading the initrd (which contain those 
raid personalities) and the scanning starts anew, this time successfully.
Why at that point the devices found earlier on are not started first is 
strange, but that might just be a race condition between the two "md0" arrays 
so that is not very important.

> NeilBrown

Thanks Neil !   It is much clearer now. :)

Maarten

