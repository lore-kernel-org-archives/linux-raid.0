From: Gordon Henderson <gordon@drogon.net>
Subject: Spinning down disks [Re: I'm about ready to do SW-Raid5 - pointers
 needed]
Date: Tue, 28 Oct 2003 08:20:35 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0310280818170.23689@unicorn.drogon.net>
References: <Pine.LNX.4.44.0310281610290.11061-100000@gw.luko.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0310281610290.11061-100000@gw.luko.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 28 Oct 2003, Luke Rosenthal wrote:

> I know there's the appropriate commands to do it, but are they risky?  If
> a drive's not mounted, but powered off, it should present no problems or
> lock up the OS, correct?

Have a look at noflushd. I've been using it for years with good results in
PCs that don't need their disks on all the time (eg. laptops). (and even
recently in my home servers with RAID1 sets)

Gordon
