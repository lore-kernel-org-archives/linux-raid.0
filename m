From: "Lewis Shobbrook" <lshobbrook@fasttrack.net.au>
Subject: RE: RE: Unable to mount root & Problems with Woody
Date: Fri, 21 Feb 2003 21:44:01 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <84BB6E1F4E011742AFB186D469FDEA9A015BDE@fastterminal.fasttrack.net.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Gordon,

I tries every trick under the sun,  cpio, cp -ax, tar, rsync...
As soon as I updated to testing all files copied on the same drive same
partition, same raidtab etc. etc.
All the files copied without failure, including symlinks, which noteably
failed with the previous 15 frustrating attempts.

Hmmm.... Not sure where the problems came from,  did you format your
/mdx using mke2fs?

> I've built several boxes to boot off raid1 using Debian woody. Eg:
> 
> drogon @ agate: df -h
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/md0              235M   18M  205M   8% /
> /dev/md1              1.9G  905M  920M  50% /usr
> /dev/md2               35G   12G   21G  34% /var
> drogon @ agate: uname -a
> Linux agate 2.4.20 #1 Wed Jan 29 12:07:57 GMT 2003 i686 
> unknown drogon @ agate: cat /etc/issue Debian GNU/\s 3.0 \n \l
> 
> 
> Theres a good howto on it all at
> 
>  http://www.tldp.org/HOWTO/Software-RAID-HOWTO-4.html#ss4.11
>
>The trick to doing the copy is to use cpio (or something else that
preserves device nodes rather than try to crete files >out of them)

>Gordon
