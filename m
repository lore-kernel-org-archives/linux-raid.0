From: starlight.2012q4@binnacle.cx
Subject: Re: question: no-bitmap RAID1 with off-site drive
Date: Mon, 12 Nov 2012 13:11:50 -0500
Message-ID: <6.2.5.6.2.20121112131017.05df8b18@binnacle.cx>
References: <6.2.5.6.2.20121111163935.05df8b18@binnacle.cx>
 <6.2.5.6.2.20121112122534.05dfec78@binnacle.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6.2.5.6.2.20121112122534.05dfec78@binnacle.cx>
References: <6.2.5.6.2.20121111163935.05df8b18@binnacle.cx>
 <6.2.5.6.2.20121112122534.05dfec78@binnacle.cx>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Probably this is more elegant:

   mdadm --create --level=1 --raid-devices=2 --spare-devices=1 /dev/sdd /dev/sde missing

At 12:26 PM 11/12/2012 -0500, starlight.2012q4@binnacle.cx wrote:
>After some pondering, think I've figure it out.
>
>Best way to go is to set it up with
>
>  --create --level=1 --raid-devices=2
>
>for the initial pair of drives, then
>
>  --fail --remove
>
>the rotate-out drive, then
>
>  --add
>
>the alternate drive.  Now there will be
>three drive slots with one "removed" and two
>"active".

