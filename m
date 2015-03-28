From: Phil Turmel <philip@turmel.org>
Subject: Re: no good deed goes unpunished...
Date: Fri, 27 Mar 2015 21:28:02 -0400
Message-ID: <551603A2.4080808@turmel.org>
References: <20150327103301.16746hhb6t1sroel@webmail.uniserve.com> <CAAMCDef5ejTu4aoYxMRxaRPvV9kKO4qwzbo9jAuPnFDYDoHo0A@mail.gmail.com> <20150327173709.19022q59t5hxh4tx@webmail.uniserve.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150327173709.19022q59t5hxh4tx@webmail.uniserve.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Stevens <geek@uniserve.com>, Roger Heflin <rogerheflin@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Dave,

{Convention on kernel.org is reply-to-all, trim quotes, and avoid
top-posting.  Please trim.}

On 03/27/2015 08:37 PM, Dave Stevens wrote:
> # cat /proc/mdstat
> 
> Personalities :
> 
> md12 : inactive   sda2[0](S)
>     732467520 blocks
> 
> md10 : inactive sdc2[2](S) sdb2[1](S)
>     1464935040 blocks

If your livecd tried to be helpful by assembling arrays, but couldn't
complete, you end up with partially-assembled inactive arrays like shown
above.  The member devices shown are *busy*, under the expectation that
the remaining device(s) will show up soon. :-)

As Roger tried to suggest, you need to run:

mdadm --stop /dev/md10
mdadm --stop /dev/md12

That'll release the member devices you need.  However, the device
assembly pairs above look suspicious.  I suggest you show mdadm -E for
those devices again to make sure you work with the correct two disks.
(sda and sdc from the original report.)

Then you can do:

mdadm --assemble --force --verbose /dev/mdX /dev/sdY2 /dev/sdZ2

with the correct substitutions for X, Y, and Z.

If that doesn't work, show the output.

Phil
