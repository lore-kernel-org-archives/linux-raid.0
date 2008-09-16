From: thomas62186218@aol.com
Subject: Re: No md superblock immediately after creating RAID 5 /dev/md0
Date: Tue, 16 Sep 2008 05:37:50 -0400
Message-ID: <8CAE5F704E5EED2-53C-2B6A@webmail-da10.sysops.aol.com>
References: <8CAD6FFC01AB7AC-524-231A@webmail-nf07.sim.aol.com>    <9b4ac8ccbe69d232ff2d77fd4e3590c2.squirrel@neil.brown.name>    <8CAD7B1E82C6F54-1068-40D8@MBLK-M01.sysops.aol.com> <d44a774691620d6964cda2b543a61be9.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d44a774691620d6964cda2b543a61be9.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, thomas62186218@aol.com
List-Id: linux-raid.ids

Hi Neil,

Thank you for your help on this. It seems like running mdadm -D > 
/etc/mdadm.conf is the way to go.

But, this raises another question. In EVMS, you do not need to ever 
tell it how to assemble an array. In fact, we could have a EVMS RAID of 
3 drives, pull the 3 drives out, and put them into a brand new system 
with no configuration files, etc. and EVMS would instantly recognize 
the RAID device, and even all volumes on it.

With mdadm, though, it seems like without /etc/mdadm.conf (or manually 
telling mdadm what to assemble), mdadm cannot really tell on its own 
what to do. This puts greater importance of course on /etc/mdadm.conf.

Is there any way around this? In other words, is there a way to 
auto-assemble arrays without using mdadm -A or without having 
/etc/mdadm.conf?

Finally, if /etc/mdadm.conf is the solution, can you advise what should 
happen when an md device is deleted? Should the "legacy" entries be 
left in /etc/mdadm.conf? Or should these be cleaned out? Any easy way 
to do this?

Thank you in advance for your help!

With Regards,
-Thomas


-----Original Message-----
From: NeilBrown <neilb@suse.de>
To: thomas62186218@aol.com
Cc: linux-raid@vger.kernel.org
Sent: Thu, 28 Aug 2008 11:01 pm
Subject: Re: No md superblock immediately after creating RAID 5 /dev/md0










On Fri, August 29, 2008 3:47 pm, thomas62186218@aol.com wrote:
>
> Hi Neil,
>
> Sorry for the confusion. I mistyped the -C command in my initial email
> (forgot the hot-spare) and thus the confusion.
>
> Here is the full output from the top using copy/paste. Thank you in
> advance for your help!!

In the first mail you sent, there was an mdadm.conf.
But now:


> root@localhost:~# cat /etc/mdadm.conf
> root@localhost:~#

there isn't.
Why is that?

If you want mdadm to assemble an array you need to tell it where to find
the devices and how to recognise them.  The mdadm.conf you had before
was exactly the right sort of thing to have.
Without it you need to be more explicit
  mdadm -A /dev/md0 /dev/sd[b-m]
maybe.
Or after creating the array
  mdadm -D > /etc/mdadm.conf

NeilBrown





