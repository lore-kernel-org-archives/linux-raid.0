From: Morten Sylvest Olsen <mso@medical-insight.com>
Subject: Re: ext3 ..
Date: Mon, 3 Jan 2005 20:47:37 +0100 (CET)
Message-ID: <20050103203803.K27797@arsenium.medical-insight.com>
References: <200501031734.j03HYO914483@www.watkins-home.com>
 <Pine.LNX.4.56.0501031754180.16453@lion.drogon.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0501031754180.16453@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Been folowing this with interst as just about everything I'm building
> these days has raid1 to boot and data (typical small server setup), and
> raid5 in larger boxes for data and ext3 ...
>
> No problems with this yet - several power failures and disks lost and it's
> all generally behaved as I expected it to. I've hot-chanaged SCSI drives
> which have failed and cold changed IDE drives at a convenient time for the
> server...
>
> I did have a problem recently though - had a disk fail in an 8-disk
> external SCSI array, arranged as a 7+1 RAID5 ... Then 5 minutes later had
> a 2nd disk fail.
>
> So to the upper layers, ext3, userland, etc. that should look like a
> catastrophic hardware failure -- anything trying to read/write to it
> should (IMO) have simply returned with IO errors.

That depends on the options when the filesystem was mounted. Or the
options set in the superblock. The choices are continue, remount
read-only or panic.

Regards, Morten
----
A: No.
Q: Should I include quotations after my reply?

