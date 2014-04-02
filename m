From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Problem Syncing raid1
Date: Wed, 2 Apr 2014 22:36:49 +0100
Message-ID: <CADNH=7EwjLirv+zdUKu-Hsrw1djLNpPoz=WSg4pJwUc0giRzOw@mail.gmail.com>
References: <BAY177-W404434C6EBAB450FA96A77C86D0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BAY177-W404434C6EBAB450FA96A77C86D0@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Christian Schmitz <schnet@hotmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2 April 2014 21:56, Christian Schmitz <schnet@hotmail.com> wrote:
> Hi everyone,
> I have a linux with the following configuration:
> /dev/md0 ( degraded mode)  (/dev/sda2)
>
> /dev/md1 ( full mode) (/dev/sda3 /dev/sdb3)
>
> The problem is if i add /dev/sdb2 to /dev/md0 start the syncing, but when reach 7% the system crash.
> I am sure that the main problem is one ( or more) badblock into /dev/sda2.

Crash? What does that mean? Kernel panic? Freeze? Reboot?
How do you know sda2 (which is sda) has bad blocks? Does it tell you?
Did you check the SMART data and run badblocks (non-destructivei f you
want) on it?

>
> How i can do to syncing the disk?.
> Obviously Is the first step to change the disk.

If it's broken, sure.

>
> Best Regards
> Christian
>


REgards,
Mathias
