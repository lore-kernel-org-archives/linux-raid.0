From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: quick Q re raid reconstruction
Date: Fri, 02 Dec 2005 10:06:34 +1100
Message-ID: <438F81FA.8080307@eyal.emu.id.au>
References: <438EE429.2030903@eyal.emu.id.au>	<17295.29744.13292.368041@cse.unsw.edu.au>	<438F7C4B.1090404@eyal.emu.id.au> <17295.32688.483645.390383@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17295.32688.483645.390383@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:
> On Friday December 2, eyal@eyal.emu.id.au wrote:
> 
>>Neil Brown wrote:
>>
>>>>Q1) What is the correct command to bring these three up as
>>>>   degraded?
>>>
>>>
>>>  mdadm --assemble --force /dev/mdX /dev/sd[abc]1
>>>
>>>However this won't work with the superblocks you have. So
>>>
>>>  mdadm --create /dev/mdX -l5 -c256 -n4 missing /dev/sda /dev/sdb /dev/sdc
>>
>>I do not see 'missing' the the mdadm manpage, but maybe Debian is too
>>far behind?
> 
> 
> It is in the section on "CREATE MODE"
> 
>        To create a "degraded" array in which some devices are missing,  simply
>        give  the  word  "missing"  in place of a device name.  This will cause
>        mdadm to leave the corresponding slot in the array empty.  For a  RAID4
>        or  RAID5 array at most one slot can be "missing"; for a RAID6 array at
>        most two slots.  For a RAID1 array, only one real device  needs  to  be
>        given.  All of the others can be "missing".
> 
> 
> 
>># mdadm --version
>>mdadm - v1.9.0 - 04 February 2005
> 
> 
> The section I quoted is from the man page for 1.12.0, but that text
> certainly predates 1.9.0.

Here is the Debian (stable) relevant 'man mdadm' section:

CREATE MODE
       Usage: mdadm --create device --chunk=X --level=Y
                   --raid-disks=Z devices

       This usage will initialise a new md array, associate some devices  with
       it, and activate the array.

       As  devices  are  added,  they  are checked to see if they contain raid
       superblocks or filesystems. They are also check to see if the  variance
       in device size exceeds 1%.

       If  any  discrepancy is found, the array will not automatically be run,
       though the presence of a --run can override this caution.

       The General Management options that are valid with --create are:

       --run  insist of running the array even if some devices look like  they
              might be in use.

       --readonly
              start the array readonly - not supported yet.

Maybe they have their own "special" man page?

>>I built it anyway and I do not see 'missing' listed in
>>	mdadm --create --help
> 
> I do.
> 
> $ /sbin/mdadm --create --help
> Usage:  mdadm --create device -chunk=X --level=Y --raid-devices=Z devices
> 
>  This usage will initialise a new md array, associate some
>  devices with it, and activate the array.   In order to create an
>  array with some devices missing, use the special word 'missing' in
>                                                         ^^^^^^^
>  place of the relevant device name.

True, I missed it :-(

fsck finished clean too, thanks again.

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au) <http://samba.org/eyal/>
	attach .zip as .dat
