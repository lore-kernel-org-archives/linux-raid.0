From: Luca Berra <bluca@comedia.it>
Subject: Re: problem during boot with linux software raid 5
Date: Sat, 14 Oct 2006 10:09:54 +0200
Message-ID: <20061014080954.GD17336@percy.comedia.it>
References: <1160778501.8826.13.camel@dual_933>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1160778501.8826.13.camel@dual_933>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, jeff@jeffunit.com
List-Id: linux-raid.ids

On Fri, Oct 13, 2006 at 06:28:21PM -0400, jeff wrote:
>I am running mandrake 2006 linux.
s/mandrake/mandriva

>uname -a reports
>Linux dual_933 2.6.12-12mdksmp #1 SMP Fri Sep 9 17:43:23 CEST 2005 i686
>Pentium III (Coppermine) unknown GNU/Linux
not strictly related to your problem, but you should really consider
applying updates from your distribution.

<snip>

>When I rebooted, the reboot hung. I think for some reason it didn't
>automatically start the md0 device, and as a result it couldn't mount
>the /dev/md0 partition in my /etc/fstab. I went into single-user mode,
>and commented out the /dev/md0 line in /etc/fsab, and I was able to
>boot. Then I executed the mdadm --create line, uncommented /etc/fstab,
>and I was able to access my data.
the command to activate an already existing raid set is "mdadm
--assemble", not "mdadm --create"

>I was reading some documentation, and it said that you can use mdadm on
>either partitions or on a device (as I did). When you have partitions, I
>read that you should set the partition type to 0xFD so they get
>autodetected during boot. I can't do this, as I don't have partitions.
this is junk documentation do not believe in it :=)

mandriva boot process uses mdadm to assemble raid devices at boot time
but you need to tell mdadm which arrays it should find at boot by
editing /etc/mdadm.conf, just run the following code snippet:

#!/bin/sh
grep -qs '/^[[:space:]]*DEVICE' /etc/mdadm.conf || \
        echo "DEVICE partitions" >> /etc/mdadm.conf

mdadm -Esc partitions | awk '
        /^ARRAY[[:space:]]/ {
                print $0, "auto=yes"
        }
' >> /etc/mdadm.conf


-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
