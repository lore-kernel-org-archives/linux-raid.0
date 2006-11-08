From: Robin Bowes <robin-lists@robinbowes.com>
Subject: Re: new array not starting
Date: Wed, 08 Nov 2006 12:55:33 +0000
Message-ID: <eisk45$1ef$1@sea.gmane.org>
References: <eirdlc$l7j$1@sea.gmane.org> <eiredo$mmo$1@sea.gmane.org> <eirfst$pd7$1@sea.gmane.org> <eirgp8$rd7$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <eirgp8$rd7$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Robin Bowes wrote:
> 
> Well, at the risk of having a complete conversation with myself, I've
> created partitions of type "fd" on each disk and re-created the array
> out of the partitions instead of the whole disk.
> 
> mdadm --create /dev/md2 --auto=yes --raid-devices=8 --level=6 /dev/sdc1
> /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sdi1 /dev/sdj1
> 
> I'm hoping this will enable the array to be auto-detected and started at
> boot.

That seemed to do the trick.

I left the array to build overnight and rebooted this morning, and
/dev/md2 started normally.

R.

