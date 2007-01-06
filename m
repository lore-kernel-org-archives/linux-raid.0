From: "Vince Spinelli" <Vince@SpinelliCreations.com>
Subject: Re: mdadm: what if - crashed OS
Date: Fri, 5 Jan 2007 23:10:31 -0500 (EST)
Message-ID: <60341.70.104.60.127.1168056631.squirrel@spinellicreations.com>
References: <63442.70.104.60.127.1167978180.squirrel@spinellicreations.com>
    <459E34C4.3050206@dgreaves.com>
Reply-To: Vince@SpinelliCreations.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <459E34C4.3050206@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: vince@SpinelliCreations.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you all for the responses and help (you guys are FAST!)...

I have successfully simulated a worst case scenario and 'rebuilt the
arrays from scratch' while preserving all data.

This is how I did it, for anyone who may run into the same jam:

1) removed OS hdd, temporarily installed scrap (read as: old 4 GB IDE HDD)
hard drive.  Installed same version of Linux - FC5, and same kernel.
2) copied (From cd backup) original mdadm.conf to /etc/mdadm.conf
3) as reccomended, executed following at command line...
[abc@123]# /sbin/mdadm --assemble --uuid=[UUIDOFARRAY] --scan /dev/md1
4) rebooted

This resulted in the array popping right up, and being accessible with all
data in tact.

Thank you again for all the help!  I will now be working on a live cd to
suite my taste, so that this all would be a little easier.

FYI --- kernel being used is a prepackaged one from Livna Repository,
2.6.17-1.2187_FC5.stk16 #1 Mon Sep 25 17:32:45 EDT 2006 i686
mdadm version being used is,
mdadm.i386 2.3.1-3

-Regards
Vince

---------------------------------------
Vince Spinelli
University at Buffalo: EE

---------------------------------------
"Kind of off his mental reservation."
- ancient cowboy wisdom.
---------------------------------------
Vince@SpinelliCreations.com
[vfs@buffalo.edu / vfs@eng.buffalo.edu]

> Assuming you can allow some downtime, get yourself a rescue CD such as
> 'RIP'
>
> This will let you boot into the machine and run mdadm commands.
>
> You don't mention kernel/mdadm versions so you may want to check they're
> close
> on the rescue CD.
>
> Then try looking at the manpage around --assemble.
> In particular you may want to try --scan and --uuid (if your RIP/live
> kernel/mdadm support it)
>
> Also check out the examples...
>
> Assuming this is a sane machine and you're not in real disaster recovery
> mode
> with drives pulled in from random boxes then look at using the literal
> string
> "--config=partitions" (see the manpage) to avoid creating an mdadm.conf
> with the
> "DEVICE partitions" line - PITA on live CDs where you just want a command
> line ;)
>
> If you can manage it, this will give you a nice warm feeling about
> recovering
> from a problem and it's pretty safe - just common sense like making sure
> the
> live CD kernel/mdadm are either up-to-date or match your production
> system.
>
> HTH
>
> Also:
>> I have thought about this, and I can't understand how 'mdadm' decides
>> the
>> health of an array.
>
> Each disk/partition used by md has a superblock which contains a unique
> UUID and
> other info, like the number of devices and the raid level. mdadm --scan
> looks
> into each partition for a superblock and notes this data. It can then
> group all
> the superblocks with the same UUID together and, for each group, knowing
> how
> many devices it should have, how many it has and how many it needs it can
> decide
> if the device can safely be assembled.
>
> David
> PS Yes, I've done this (too many times!)
>



---------------------------------------------------------
SpinelliCreations Secure Webmail: Powered by SquirrelMail
