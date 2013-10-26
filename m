From: Phil Turmel <philip@turmel.org>
Subject: Re: assembling array after disk failure
Date: Sat, 26 Oct 2013 18:03:42 -0400
Message-ID: <526C3C3E.6040406@turmel.org>
References: <526C2E5F.1060507@woh.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <526C2E5F.1060507@woh.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Knight <dknight1989@woh.rr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/26/2013 05:04 PM, Dan Knight wrote:
> Hello after some trouble with disks, I am trying to reassemble an
> array.  When I start the array, I am told I don't have enough disks to
> start.  What is really strange to me is that when I examine the disks in
> the array, mdadm gives me different overall information for different
> disks.  What do I need to do to assemble the array?
> 
> **[root@server etc]# mdadm -As
> **mdadm: /dev/md127 assembled from 3 drives - not enough to start the
> array.**
> *[root@server etc]# cat /proc/mdstat*
> Personalities :
> md127 : inactive sdf[2](S) sde[4](S) sdb[3](S) sdc[1](S) sdd[0](S)
>       9767572480 blocks super 0.91

"--force" is your friend in such situations.

mdadm --stop /dev/md127
mdadm -Af /dev/md127 /dev/sd[bcdef]

You haven't given enough information for any advice on avoiding future
trouble...

Phil
