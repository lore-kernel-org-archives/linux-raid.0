From: dean gaudet <dean@arctic.org>
Subject: Re: raid5 software vs hardware: parity calculations?
Date: Mon, 15 Jan 2007 13:25:54 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0701151321190.16472@twinlark.arctic.org>
References: <2A887D754684B6703B52E126@emerald.sei.cmu.edu>
 <Pine.LNX.4.64.0701120935000.18431@twinlark.arctic.org>
 <F4B05AD60951BBA089A81535@emerald.sei.cmu.edu>
 <e9c3a7c20701130120o246f5cf1i8d364777123c50d8@mail.gmail.com>
 <45A917B8.2060706@tmr.com> <eobpl9$df3$1@sea.gmane.org> <45AB9DC6.50509@tmr.com>
 <45ABAA43.2000902@robinbowes.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45ABAA43.2000902@robinbowes.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Bowes <robin-lists@robinbowes.com>
Cc: Bill Davidsen <davidsen@tmr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 15 Jan 2007, Robin Bowes wrote:

> I'm running RAID6 instead of RAID5+1 - I've had a couple of instances
> where a drive has failed in a RAID5+1 array and a second has failed
> during the rebuild after the hot-spare had kicked in.

if the failures were read errors without losing the entire disk (the 
typical case) then new kernels are much better -- on read error md will 
reconstruct the sectors from the other disks and attempt to write it back.

you can also run monthly "checks"...

echo check >/sys/block/mdX/md/sync_action

it'll read the entire array (parity included) and correct read errors as 
they're discovered.

-dean
