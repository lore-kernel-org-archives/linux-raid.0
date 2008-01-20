From: David Greaves <david@dgreaves.com>
Subject: Re: how to create a degraded raid1 with only 1 of 2 drives ??
Date: Sun, 20 Jan 2008 21:38:45 +0000
Message-ID: <4793BF65.3030002@dgreaves.com>
References: <20080120192801.GA11149@earthlink.net> <20080120195253.GA11393@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080120195253.GA11393@earthlink.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, mlaks@post.harvard.edu
List-Id: linux-raid.ids

Mitchell Laks wrote:
> I think my error was that maybe I did not
> do write the fdisk changes to the drive with 
> fdisk w

No - your problem was that you needed to use the literal word "missing"
like you did this time:
> mdadm -C /dev/md0 --level=2 -n2 /dev/sda1 missing

[however, this time you also asked for a RAID2 (--level=2) which I doubt would work]

David
