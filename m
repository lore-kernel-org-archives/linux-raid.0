From: Krzysztof Adamski <k@adamski.org>
Subject: Re: Advice on build a RAID6
Date: Sat, 22 Oct 2011 08:57:27 -0400
Message-ID: <1319288247.3649.21158.camel@oxygen.netxsys.com>
References: <1319231862.3649.19262.camel@oxygen.netxsys.com>
	 <alpine.DEB.2.00.1110221053460.11931@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1110221053460.11931@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 2011-10-22 at 10:54 +0200, Mikael Abrahamsson wrote:
> On Fri, 21 Oct 2011, Krzysztof Adamski wrote:
> 
> > One requirement is to partition the drives at 99% for the RAID.
> 
> Why? What problem are you solving by using partitions?
> 

There are at least two, you get to control the size of the area used
instead of depending the size of the drive, if in the future you change
a drive with a different make/model that is a bit smaller, you don't
have problems then.

You can store extra information in a second partition that may help you
with future recovery.

When you have lots of drives in a box (20 to 30) it makes it easy to
tell a new drive from an existing drive by looking at the partition
table. You can't count on device names in case of problems, since
usually you would have to reboot the box specially when it hangs.

This are just a few that I can think of from my experience managing
boxes with lots of drives and MD RAID for more then last 10 years.

I know that the only downside is that the partitions have to be
correctly aligned for the 4K drives, I don't know of any other reasons
not to use partitions.

K

