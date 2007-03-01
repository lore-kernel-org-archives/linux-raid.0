From: Laurent CARON <lcaron@unix-scripts.info>
Subject: Re: Growing a raid 6 array
Date: Fri, 02 Mar 2007 00:08:51 +0100
Message-ID: <45E75D03.2050906@unix-scripts.info>
References: <45E72549.2080108@unix-scripts.info> <Pine.LNX.4.64.0703011728270.7560@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0703011728270.7560@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:
> You can only grow a RAID5 array in Linux as of 2.6.20 AFAIK.


From the man page:

Grow   Grow (or shrink) an array, or otherwise reshape it in some way.
Currently supported growth options including changing the active size of
component devices in RAID level 1/4/5/6 and changing the number of
active devices in RAID1.
