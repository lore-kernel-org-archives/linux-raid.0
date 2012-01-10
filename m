From: Michal Soltys <soltys@ziu.info>
Subject: Re: Renaming MD devices (metadata=1.1)
Date: Tue, 10 Jan 2012 11:59:15 +0100
Message-ID: <4F0C1A03.8020509@ziu.info>
References: <4F0BD6EA.8010007@grm.polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F0BD6EA.8010007@grm.polymtl.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Gilbert Kowarzyk <kowarzyk@grm.polymtl.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10.01.2012 07:12, Gilbert Kowarzyk wrote:
>
>
> # mdadm --examine --scan /dev/sdc1
> =================================>
> ARRAY /dev/md/9 metadata=1.1 UUID=0fa7f737:7806ca61:fb89edd6:14aa351a
> name=xyz.homelinux.com:9
> <=================================
>
>
> # mdadm --examine --scan /dev/sdd1
> =================================>
> ARRAY /dev/md/9 metadata=1.1 UUID=0fa7f737:7806ca61:fb89edd6:14aa351a
> name=xyz.homelinux.com:9
> <=================================
>
>
> # mdadm --detail --scan
> =================================>
> ARRAY /dev/md/xyz.homelinux.com:9 metadata=1.1
> name=xyz.homelinux.com:9 UUID=0fa7f737:7806ca61:fb89edd6:14aa351a
> <=================================
>
> # blkid
> =================================>
> /dev/md127: UUID="c301cf13-cfaf-4f56-887e-c648caf5a931" TYPE="ext4"
> <=================================
>
> in /etc/fstab I have:
> =================================>
> UUID=c301cf13-cfaf-4f56-887e-c648caf5a931 /DATA    ext4  defaults 1 2
> <=================================
>
> and in /etc/mdadm.conf I have:
> =================================>
> ARRAY /dev/md/xyz.homelinux.com:9 metadata=1.1
> name=xyz.homelinux.com:9 UUID=0fa7f737:7806ca61:fb89edd6:14aa351a
> <=================================
>
>
> To me, the line that looks suspicious is the one we get from "mdadm
> - --detail --scan". All the devices that "look right" say "ARRAY
> /dev/md/X" where X is a number.
>
> I fixed this temporarily by stopping the array and re-assembling it with:
>
> mdadm --assemble /dev/md9 --name=9 --update=name /dev/sdc1 /dev/sdd1
>

You updated name stored in the metadata, and assembled the array 
explicitly requesting particular standard name. But the names directly 
under /dev are managed/assigned by udev.

As the /dev/md9 was explicitly given in this form, the MD_DEVNAME was 
not present in 'mdadm --detail --export' output, thus /dev/md/9 was not 
created by mdadm's udev rules - but it would have been if you had done 
mdadm --assemble /dev/md/9 ...

>
> Then the mdadm --detail --scan line says:
> ARRAY /dev/md/9 metadata=1.1 name=xyz.homelinux.com:9
> UUID=0fa7f737:7806ca61:fb89edd6:14aa351a
>
> ... which makes more sense to me (it looks like the other ones.
>
> Yet, when I reboot the computer this "temporarily fixed" array returns
> to /dev/md127.

But you should have proper, permanent name (as a symlink) under /dev/md/

Autoassembly (be it -I used with modern mdadm's udev rules) or -A will 
try to honor the device name if the name is in standard format, so for 
mdadm.conf with ARRAY /dev/md/9 ... - you will (usually) get /dev/md9 - 
but this it's not really worth chasing after or relying on (and what if 
the name is already taken ?).

Just write:

ARRAY /dev/md/somename UUID=0fa7f737:7806ca61:fb89edd6:14aa351a
ARRAY somename UUID=0fa7f737:7806ca61:fb89edd6:14aa351a

in which case 'somename' will be created under /dev/md/ regardless of 
the name stored in the metadata, or just

ARRAY UUID=0fa7f737:7806ca61:fb89edd6:14aa351a

so the metadata (without hostname prefix) will be used.

So to sum it up - if '9' is what you're after - then the ARRAY line with 
just UUID is all you should be needing - and you should always get 
/dev/md/9 (pointing to something else assigned dynamically).

If udevd is not running (hardly interesting case anymore), then mdadm 
will fall back to the pre-udev behavior and setup the nodes itself, 
though the rules are slightly different then.

