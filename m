From: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
Subject: RE: Using mdadm.conf to create arrays
Date: Fri, 7 Mar 2003 11:53:18 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <8075D5C3061B9441944E137377645118012E87@cinshrexc03.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: Derek Vadala <derek@cynicism.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The shell script sounds like a better idea.

Basically here's what I'm doing - I'm replacing our hardware RAID setup
with Linux software RAID.  We have 56 disks attached to this system and
we're going to run a RAID10 array.  I have to create 26 RAID1 arrays (52
disks mirrored + four spares) and then strip across those.  I wanted to
have a "one-stop-shop" if you will with mdadm and mdadm.conf so if there
is a way to setup mdadm.conf once to create the arrays and to start them
upon boot, I would like that instead of having to create them all by
hand and then use 'mdadm --examine --scan' to create mdadm.conf and
after that's created then assign spare-groups.

Also, would there be any benefits with doing RAID100 (2 RAID10 sets
striped) other than I could go over the MAX_SB_DISKS limit (according to
dmesg MAX_SB_DISKS=27 which would indicate to me that I can only make an
md device with 27/28 real block devices)?  Would I get any performance
benefit, or would performance actually decrease?

I sent an email to the list a couple of weeks ago to see if anyone has
done something this large with software RAID and Maurice from HardData
said that he had, but that's all I've heard so far.  Have you heard of
this magnitude in production?  I want to make sure I'm not digging a
hole for myself :)

Thanks,
Andy.

-----Original Message-----
From: Derek Vadala [mailto:derek@cynicism.com] 
Sent: Friday, March 07, 2003 11:15 AM
To: linux-raid@vger.kernel.org
Cc: Rechenberg, Andrew
Subject: Re: Using mdadm.conf to create arrays


On Fri, 7 Mar 2003, Rechenberg, Andrew wrote:

> With raidtools I can create the conf file and then do an 'mkraid 
> /dev/md[0-9]' and that will create those ten arrays.  Is there a way 
> to accomplish something similar with mdadm and mdadm.conf?

I don't think mdadm has the functionality you're looking for. Maybe I'm
missing something, but why not just create a shell script to create the
arrays? Surely some substitutions and regex's in vi to build mdadm -C
commands would be simpler than creating a config file. Perhaps if you
explained what you're trying to do a little bit more...

--
Derek Vadala, derek@cynicism.com, http://www.cynicism.com/~derek


