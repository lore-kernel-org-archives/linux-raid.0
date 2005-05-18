From: Andre Noll <noll@mathematik.tu-darmstadt.de>
Subject: Re: Problems setting up RAID1
Date: Wed, 18 May 2005 18:22:43 -0000
Message-ID: <slrnd8n1vj.na8.noll@p133.mathematik.tu-darmstadt.de>
References: <d6danj$nmr$1@sea.gmane.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 17 May 2005 13:48:21 -0400 you wrote in local.lists.linux-raid:
> I am having problems setting up RAID 1 using Fedora core 3.  Here are
> the steps that I have taken to date.

[...]


>     Note: I was able to execute the command:
>     mount / -o remount,rw

That command should be the first thing to to after fscking /. Usually it
is run from a bootup script.

> Any suggestiong on what I should try next.

Did you try root=/dev/md7 in your lilo.conf (or at the lilo prompt)?

And please check you have the correct rootfs entry in your /etc/fstab.
-- 
Andre Noll, http://www.mathematik.tu-darmstadt.de/~noll

