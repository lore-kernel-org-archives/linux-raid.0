From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Unable to mount root & Problems with Woody
Date: Fri, 21 Feb 2003 10:24:25 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.43.0302211017400.16246-100000@unicorn.drogon.net>
References: <84BB6E1F4E011742AFB186D469FDEA9A015BDD@fastterminal.fasttrack.net.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <84BB6E1F4E011742AFB186D469FDEA9A015BDD@fastterminal.fasttrack.net.au>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 21 Feb 2003, Lewis Shobbrook wrote:

> I've have noted something that some of you may find interest in.  I have
> tried fruitlessly to get raid1 working in with Debian woody on a 2.4.18
> kernel using raidtools2.  I tried countless different means to copy the
> root filesystem onto the raid filesystem.  The best I managed to achieve
> was about half a file system. All attempts to mount lilo using lilo -r
> /mnt/md0 device resulted in failure because nodes in the dev directory
> would never copy onto the mdX filesystem.

I've built several boxes to boot off raid1 using Debian woody. Eg:

drogon @ agate: df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/md0              235M   18M  205M   8% /
/dev/md1              1.9G  905M  920M  50% /usr
/dev/md2               35G   12G   21G  34% /var
drogon @ agate: uname -a
Linux agate 2.4.20 #1 Wed Jan 29 12:07:57 GMT 2003 i686 unknown
drogon @ agate: cat /etc/issue
Debian GNU/\s 3.0 \n \l


Theres a good howto on it all at

  http://www.tldp.org/HOWTO/Software-RAID-HOWTO-4.html#ss4.11

The trick to doing the copy is to use cpio (or something else that
preserves device nodes rather than try to crete files out of them)

Gordon


