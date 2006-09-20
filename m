From: Daniel Pittman <daniel@rimspace.net>
Subject: Re: USB disks for RAID storage
Date: Wed, 20 Sep 2006 12:11:56 +1000
Message-ID: <87irjj4783.fsf@rimspace.net>
References: <59430.213.136.43.252.1157976989.squirrel@webmail.adocca.com>
	<b53b67d20609110610v5d4a63a9ube77d918b0406484@mail.gmail.com>
	<87odtfe5l7.fsf_-_@rimspace.net>
	<62b0912f0609180143y7fb3f9d6m7024c41edb709bcd@mail.gmail.com>
	<b53b67d20609190259v44d7306bya61a487fd055888b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Patrick Hoover" <phoover.eml@gmail.com> writes:

Top posting makes it hard to keep meaningful context in the discussion.
It would be nice if you would avoid that in future.

[... RAID on USB attached disks ...]

> With USB interfaced disks, it appears that you lose access to the
> SMART capabilities built into the disks. My understanding is that
> there is no way to map the SMART transactions onto USB - it would be
> great if I were mistaken here. 

You are mistaken: it is perfectly possible for a USB disk enclosure to
translate SMART requests to the disk.  

However you are not very much mistaken: none of them actually /do/ that
translation.  So, in practice you do give up on SMART notification of
pending issues.

> There was another thread here on testing arrays a short while ago. My
> take on that was using SMART really was the way to go. However, in
> this case, where SMART doesn't appear to work, what are the best
> options for monitoring disk integrity / degradation?

The case of "where SMART doesn't appear to work" is "if (1)" -- SMART
does not always alert you to a disk failure before it shows up.  I say
this from the experience of servers with extensive SMART monitoring that
have failed disks without warning.

So, don't assume that SMART is going to catch every fault for you, or
that you really lose that much without it.[1]

Regards,
        Daniel

Footnotes: 
[1]  I have had one disk failure noted by SMART first, dozens of
     failures noted by MD kicking out a disk, and one case where I
     swapped out the disk as SMART showed increasing error counts over
     the last couple of years.

-- 
Digital Infrastructure Solutions -- making IT simple, stable and secure
Phone: 0401 155 707        email: contact@digital-infrastructure.com.au
                 http://digital-infrastructure.com.au/

