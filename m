From: Phil Turmel <philip@turmel.org>
Subject: Re: [Recovery] RAID10 hdd failureS help requested
Date: Tue, 24 Sep 2013 10:23:43 -0400
Message-ID: <5241A06F.10704@turmel.org>
References: <CAB4fJqfd1zrw_AS89ufysfyCoKNf6VYj81xov0=7y0aXoYtjxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB4fJqfd1zrw_AS89ufysfyCoKNf6VYj81xov0=7y0aXoYtjxw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Karel Walters <karel.walters@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Karel,

On 09/24/2013 09:12 AM, Karel Walters wrote:
> Hopefully someone can help me with this.

Likely.

> I have a 7 drive raid10 array.
> A single drive failed this night and the 7th spare drive was trying to
> pickup the failed drive.
> During the re-sync a second drive failed and the re-sync stopped.

Oh, if I had a dollar for every time I write the following:

Your report sounds like the classic timeout mismatch problem when using
non-raid (consumer) drives in a raid array.  You will need to spend some
time reading archived messages on this list to understand the problem.
I recommended searching for various combinations of "scterc" "error
recovery" "timeout mismatch" "ure" and "unrecoverable read error".

> Now I know I should replace the failed drives but I would like to have
> them online one more time for some critical files that were produced
> last night.

If the problem is timeout mismatch, your drives are probably fine.

> As it stands I tried:
> 
> remove from array and re-add:
> This failed with:
> mdadm: --re-add for /dev/sdd1 to /dev/md1 is not possible
> 
> I tried forced reassemble:
> this failed:
> mdadm: failed to add /dev/sde1 to /dev/md1: Device or resource busy
> mdadm: failed to add /dev/sdj1 to /dev/md1: Device or resource busy
> mdadm: failed to RUN_ARRAY /dev/md1: Input/output error
> 
> From what I read online I should re-create the array with
> assume-clean, but I am quite hesitant to do so since a single type
> means the destruction of my raid array.
> 
> Could someone please advice?
> 
> 
> Added is the output from --examine and --detail
> 
> /dev/md1:
>         Version : 1.2
>   Creation Time : Thu Apr 26 11:33:56 2012
>      Raid Level : raid10
>   Used Dev Size : -1
>    Raid Devices : 6
>   Total Devices : 6
>     Persistence : Superblock is persistent
> 
>     Update Time : Tue Sep 24 13:52:16 2013
>           State : active, degraded, Not Started

This suggests you should try "mdadm /dev/md1 --run" before anything
else.  The drives that have dropped out should not have broken the far
mirrors (I think).

If this works, take your backup right away. (But fix the timeouts if
that is part of your problem.)

If that doesn't work, report the following:

dmesg

for x in /sys/block/*/device/timeout ; do echo $x : $(< $x) ; done

for x in /dev/sd[c-i] ; do echo $x ; smartctl -x $x ; done

HTH,

Phil
