From: Mike Hardy <mhardy@h3c.com>
Subject: Re: Care and feeding of RAID?
Date: Tue, 05 Sep 2006 09:23:56 -0700
Message-ID: <44FDA49C.2000802@h3c.com>
References: <44FD722C.7050608@waldoware.com> <Pine.LNX.4.56.0609051414310.17570@lion.drogon.net> <44FD91D1.7090501@maine.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44FD91D1.7090501@maine.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Cousins <steve.cousins@maine.edu>
Cc: Gordon Henderson <gordon@drogon.net>, Paul Waldo <pwaldo@waldoware.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Steve Cousins wrote:

> MAILADDR cousins@limpet-gb.umeoce.maine.edu
> ARRAY /dev/md0 level=raid5 num-devices=3
> UUID=39d07542:f3c97e69:fbb63d9d:64a052d3
> devices=/dev/sdb1,/dev/sdc1,/dev/sdd1

If you list the devices explicitly, you're opening the possibility for
errors when the devices are re-ordered following insertion (or removal)
of any other SATA or SCSI (or USB storage) device

I think you want is a "DEVICE partitions" line accompanied by ARRAY
lines that have the UUID attribute you've already got in there.

-Mike
