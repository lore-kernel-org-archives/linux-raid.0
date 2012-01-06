From: Phil Turmel <philip@turmel.org>
Subject: Re: What just happened to my disks/RAID5 array?
Date: Fri, 06 Jan 2012 08:16:00 -0500
Message-ID: <4F06F410.4070807@turmel.org>
References: <4E6F13F7.6070507@truschnigg.info> <4E6F4091.7050206@turmel.org> <4E6FA76A.90206@truschnigg.info> <4E7092F1.5010209@turmel.org> <4E70EFA8.4080706@truschnigg.info> <4E70FE5B.5080601@turmel.org> <20120106105143.GA2932@vault.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120106105143.GA2932@vault.local>
Sender: linux-raid-owner@vger.kernel.org
To: Johannes Truschnigg <johannes@truschnigg.info>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Good Morning, Johannes,

On 01/06/2012 05:51 AM, Johannes Truschnigg wrote:
> Hello again Phil and everyone else who's having a peek,
> 
> you see, I finally had the chance to migrate all the disks to a new machine,
> and figured I'd try my luck at getting back the data on my precious array.
> It's been a while since I had access to it, but having that data available all
> the time is not as important as having it at all, as I use the box mostly to
> store old(er) backups. I definitely would like to have them back at some point
> in time, however ;)
> 
> So yesterday, I upgraded all the software on the boot drive (running Gentoo),
> and now I have Kernel 3.2.0 and mdadm 3.1.5, and all the drives attached to an
> AMD SB850 in AHCI mode. Drive-wise, everything looks as expected - all device
> nodes are there, fdisk reports the correct size, and SMART data can be read
> w/o problems. Assemling the array, however, fails, and I promised in a
> previous mail in this thread that I were to come back to the list and post the
> info I got before venturing forth. Well, here I am now:

Warning!  I saw bug report on LKML yesterday involving LVM and the brand new
kernel v3.2, so you might want to pull back.  v3.1.5 was known good in that
report.

> I have the array in stopped state, so /proc/mdstat contains no arrays at this
> time. Now I run the following command which yields this output:
> 
> --- snip ---
> # mdadm -v --assemble -u "19e260e6:db3cad86:0541487d:a1bae605" /dev/md0 
> mdadm: looking for devices for /dev/md0
> mdadm: cannot open device /dev/sda1: Device or resource busy
> mdadm: /dev/sda1 has wrong uuid.
> mdadm: cannot open device /dev/sda: Device or resource busy
> mdadm: /dev/sda has wrong uuid.

I'm guessing that /dev/sda contains your boot and root filesystems, and that
this isn't an error.

> mdadm: /dev/sdf is identified as a member of /dev/md0, slot 3.
> mdadm: /dev/sde is identified as a member of /dev/md0, slot 1.
> mdadm: /dev/sdd is identified as a member of /dev/md0, slot 2.
> mdadm: /dev/sdc is identified as a member of /dev/md0, slot 4.
> mdadm: /dev/sdb is identified as a member of /dev/md0, slot 0.
> mdadm: added /dev/sdb to /dev/md0 as 0
> mdadm: added /dev/sdd to /dev/md0 as 2
> mdadm: added /dev/sdf to /dev/md0 as 3
> mdadm: added /dev/sdc to /dev/md0 as 4
> mdadm: added /dev/sde to /dev/md0 as 1
> mdadm: /dev/md0 assembled from 2 drives - not enough to start the array.
> --- snip ---

Those slot numbers are *really* important.

> It seems that mdadm would be able to identify all five original components of
> my array, but later decides that it found only two of them, and therefore
> can't start the array. /proc/mdstat, at this point in time, shows the
> following:
> 
> --- snip ---
> md0 : inactive sde[1](S) sdc[5](S) sdf[3](S) sdd[2](S) sdb[0](S)
>       7325687800 blocks super 1.2
> --- snip ---
> 
> The (S) should indicate the component being marked as "spare", right (mdstat
> really should have a manpage with a short overview of the most commonly
> observed abbreviations, symbols and terms - I guess I'll volunteer if you
> don't tell me that's already documented somewhere)?
> 
> Shall I just try "-A --force" and that's supposed to kick the array enough to
> start again? Or is there anything else you could and would recommend before
> resorting to that?

Yes, --assemble --force.

> One thing I forgot to mention is that I cannot guarantee that the order of the
> drives is still the same as it was in the old box (device node names for the
> component disks could have changed), but I'm convinced that's not a problem
> and I mention it only for the sake of completeness.

May I suggest getting an lsdrv [1] report, which will give you the serial numbers
of your disks versus the device assignments, for later reference.  And again
after it's all running, for completeness.

> I have attached a file with the output of `mdadm -E` for each of the
> components for your viewing pleasure - thanks in advance for anyone's time and
> effort who's looking into this!

HTH,

Phil

[1] http://github.com/pturmel/lsdrv
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk8G9A0ACgkQBP+iHzflm3BlUACcCoUX1YdI0vM/GmNITIRAXz5q
EsIAn3FDUd92X4CG8YPNWEpc/2AC/icG
=R2R2
-----END PGP SIGNATURE-----
