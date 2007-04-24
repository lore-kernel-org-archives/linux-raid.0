From: David Greaves <david@dgreaves.com>
Subject: Re: Partitioned arrays initially missing from /proc/partitions
Date: Tue, 24 Apr 2007 10:37:42 +0100
Message-ID: <462DCFE6.4050708@dgreaves.com>
References: <16046.1177356707@mdt.dhcp.pit.laurelnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16046.1177356707@mdt.dhcp.pit.laurelnetworks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Accetta <maccetta@laurelnetworks.com>, Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mike Accetta wrote:
> David Greaves writes:
> 
> ...
>> It looks like the same (?) problem as Mike (see below - Mike do you have a
>> patch?) but I'm on 2.6.20.7 with mdadm v2.5.6
> ...
> 
> We have since started assembling the array from the initrd using
> --homehost and --auto-update-homehost which takes a different path through
> the code, and in this path the kernel figures out there are partitions
> on the array before mdadm exists.
Just tried that - doesn't work :)


> For the previous code path, we had been ruuning with the patch I described
> in my original post which I've included below.  I'd guess that the bug
> is actually in the kernel code and I looked at it briefly but couldn't
> figure out how things all fit together well enough to come up with a
> patch there.  The user level patch is a bit of a hack and there may be
> other code paths that also need a similar patch.  I only made this patch
> in the assembly code path we were executing at the time.
> 
> ==== BUILD/mdadm/mdadm.c#2 (text) - BUILD/mdadm/mdadm.c#3 (text) ==== content
> @@ -983,6 +983,10 @@
>                                                                NULL,
>                                                                readonly, runstop, NULL, verbose-quiet, force);
>                                         close(mdfd);
> +                                       mdfd = open(array_list->devname, O_RDONLY); 
> +                                       if (mdfd >= 0) {
> +                                           close(mdfd);
> +                                       }
>                                 }
>                 }
>                 break;

Thanks Mike

But this doesn't work for me either :(

I changed array_list to devlist inline with 2.6.9 and it compiles and runs OK.

teak:~# mdadm --stop /dev/md_d0
mdadm: stopped /dev/md_d0
teak:~# /everything/devel/mdadm/mdadm-2.5.6/mdadm --assemble /dev/md_d0
/dev/sd[bcdef]1
mdadm: With Fudge.
mdadm: /dev/md_d0 has been started with 5 drives.
mdadm: Fudging partition creation.
teak:~# mount /media
mount: /dev/md_d0p1 is not a valid block device
teak:~#

I also wrote a small c program to call the RAID_AUTORUN ioctl - that didn't work
either because I'd compiled RAID as a module so the ioctl isn't defined.

currently recompiling the kernel to allow autorun...

David
