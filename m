From: Mitchell Laks <mlaks@verizon.net>
Subject: Re: disaster. raid1 drive failure rsync=DELAYED why?? please help
Date: Sun, 13 Mar 2005 09:32:49 -0500
Message-ID: <200503130932.50098.mlaks@verizon.net>
References: <200503122351.23430.mlaks@verizon.net>
 <42340CA3.8020900@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-8-i
Content-Transfer-Encoding: 7bit
In-reply-to: <42340CA3.8020900@dgreaves.com>
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday 13 March 2005 04:49 am, you wrote:
> kernel version, mdadm version?

debian sarge:

wustl@A1:~$ uname -a
Linux A1 2.6.8-1-386 #1 Thu Nov 25 04:24:08 UTC 2004 i686 GNU/Linux
wustl@A1:~$ export COLUMNS=200;dpkg -l|grep mdadm
ii  mdadm                                        1.8.1-1                       
wustl@A1:~$ apt-cache show mdadm
Package: mdadm
Priority: optional
Section: admin
Installed-Size: 252
Maintainer: Mario Joussen <joussen@debian.org>
Architecture: i386
Version: 1.8.1-1
Replaces: mdctl
Depends: libc6 (>= 2.3.2.ds1-4), makedev, debconf (>> 0.5)
Conflicts: mdctl (<< 0.7.2), raidtools2 (<< 1.00.3-12.1)
Filename: mdadm_1.8.1-1_i386.deb
Size: 104964
MD5sum: 0550c71ce7c24d77b93bac373cd98839
Description: Manage MD devices aka Linux Software Raid
 mdadm is a program that can be used to create, manage, and monitor MD
 devices.  As such it provides a similar set  of functionality  to the
 raidtools packages.
 .
 Unlike raidtools, mdadm can perform (almost) all of its functions
 without having a configuration file.


Thank you.
Mitchell Laks

>
> David
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
