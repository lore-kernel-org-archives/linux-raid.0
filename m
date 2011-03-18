From: hansbkk@gmail.com
Subject: Re: disk order problem in a raid 10 array
Date: Sat, 19 Mar 2011 00:22:34 +0700
Message-ID: <AANLkTin0L4wV3uFFhkeWPptvEddsS5ZntxVx51x2rjW_@mail.gmail.com>
References: <201103181549.20835.xavier@alternatif.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201103181549.20835.xavier@alternatif.org>
Sender: linux-raid-owner@vger.kernel.org
To: Xavier Brochard <xavier@alternatif.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Mar 18, 2011 at 9:49 PM, Xavier Brochard <xavier@alternatif.org> wrote:
> disk order is mixed between each boot - even with live-cd.

> is that normal?

If nothing is changing and the order is swapping really every boot,
then IMO that is odd.

But it's very normal for  ordering to change from time to time, and
definitely when elements change - kernel version/flavor, drivers, BIOS
settings, etc.

Part of my SOP is now to record both mdadm and the boot loader's
ordering against serial number and UUID of drives when creating an
array, and to put the relevant information on labels securely attached
to the physical drives, along with creating a map of their physical
location and taping that inside the case.

It's critical to know what's what in a crisis. . .
