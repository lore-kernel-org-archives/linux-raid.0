From: James Ralston <qralston+ml.linux-raid@andrew.cmu.edu>
Subject: stacked raid devices not autodetected?
Date: Thu, 02 Dec 2004 17:32:24 -0500
Message-ID: <912C966151E990A5186A8A78@pcmy.sei.cmu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have several raid devices that I created with the following
commands:

    mdadm --create /dev/md0 --level=mirror --raid-devices=2 /dev/sd{b,h}1
    mdadm --create /dev/md1 --level=mirror --raid-devices=2 /dev/sd{c,i}1
    mdadm --create /dev/md2 --level=mirror --raid-devices=2 /dev/sd{d,j}1
    mdadm --create /dev/md3 --level=mirror --raid-devices=2 /dev/sd{e,k}1
    mdadm --create /dev/md4 --level=mirror --raid-devices=2 /dev/sd{f,l}1
    mdadm --create /dev/md5 --chunk=256 --level=stripe --raid-devices=5 /dev/md{0,1,2,3,4}

On boot, the kernel automatically detects and starts md0 through md4.
However, md5 is *not* autodetected.  Using the RAID_AUTORUN ioctl also
has no effect.  The only way I've found to reliably start md5 is to
have rc.sysinit run "mdadm -assemble --scan".

Is this a bug?  A design limitation?  Something else?

(I am currently using kernel-2.6.9-1.675_EL on the RHEL 4AS beta.  But
I've never been able to get autodetection of stacked raid devices to
work using any kernel.)

-- 
James Ralston, Information Technology
Software Engineering Institute
Carnegie Mellon University, Pittsburgh, PA, USA

