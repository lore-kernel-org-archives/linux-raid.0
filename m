From: Phil Turmel <philip@turmel.org>
Subject: Re: failed RAID 5 array
Date: Fri, 14 Nov 2014 11:04:20 -0500
Message-ID: <54662804.7040005@turmel.org>
References: <1415807882.4241.36.camel@lappy.neofreak.org>	 <54653735.90007@turmel.org> <1415971164.4241.38.camel@lappy.neofreak.org>	 <546606D4.5070406@turmel.org> <1415974131.4241.41.camel@lappy.neofreak.org>	 <5466173F.2060007@turmel.org> <1415980414.4241.49.camel@lappy.neofreak.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1415980414.4241.49.camel@lappy.neofreak.org>
Sender: linux-raid-owner@vger.kernel.org
To: DeadManMoving <sequel@neofreak.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/14/2014 10:53 AM, DeadManMoving wrote:
> Hi Phil,

> That is my plan to closely look at devices role to ensure proper order
> in array creation. To avoid any mistake, i was planning to
> use /dev/sda /dev/sdb /dev/sdc syntax instead of /dev/sd{a,b,c}, it's
> probably the same, is it not?

Yes.  Braces are expanded as given.  Square brackets are expanded in the
order found in the filesystem, not the order given.

> Like said in my original post, i am making duplicate copies of each
> disk, just to be extra safe. I already did it for two disks i have on
> hands. I have ordered and waiting for two other drives to come in. As
> soon as the copies will be done for the two other disks, i will try that
> procedure. I will use the --data-offset parameter as you suggest.

You've provided very good detail in your report, so in your situation I
would proceed with the original drives.  But an extra layer of safety
doesn't hurt.  And you'll have enough drives to switch to raid6 (highly
recommended!) when your array is stable again.

> Thank you so much for your help!

You're welcome.

Phil

