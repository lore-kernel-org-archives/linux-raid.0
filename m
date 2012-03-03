From: Bryan Mesich <bryan.mesich@ndsu.edu>
Subject: Re: Hints on reducing kickouts
Date: Sat, 3 Mar 2012 16:24:24 -0600
Message-ID: <20120303222424.GA29339@atlantis.cc.ndsu.nodak.edu>
References: <CAOscVd+CWwJoRknhGOvexC7w64o_5H-Q+USheTYZULJbJ8EOYA@mail.gmail.com> <20120301182218.GB9106@atlantis.cc.ndsu.nodak.edu> <CAOscVdKo6aU+H6xGfpMTdN_XCAVnF3V2XXuqN4V5rYBux3e3_Q@mail.gmail.com>
Reply-To: Bryan Mesich <bryan.mesich@ndsu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOscVdKo6aU+H6xGfpMTdN_XCAVnF3V2XXuqN4V5rYBux3e3_Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: John Obaterspok <john.obaterspok@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Mar 03, 2012 at 10:28:20PM +0100, John Obaterspok wrote:
> Please see below for errors I get when trying to add internal bitmap.

[snip...]
 
> okay, I'm trying to add an interal bitmap to see how much it slows down things:
> 
> [root@Emperor ~]# mdadm --version
> mdadm - v3.2.3 - 23rd December 2011
> 
> 
> [root@Emperor ~]# mdadm --grow --bitmap=internal /dev/md2
> mdadm: failed to set internal bitmap.

I think you are using the wrong cmd line syntax.  Try the
following for adding an internal bitmap to /dev/md2

mdadm --grow /dev/md2 --bitmap=internal

If you want to use an external bitmap, use --bitmap="path to
file".

> [root@Emperor ~]# mdadm --examine-bitmap /dev/md2
>         Filename : /dev/md2
>            Magic : 00000000
> mdadm: invalid bitmap magic 0x0, the bitmap file appears to be corrupted
>          Version : 0
> mdadm: unknown bitmap version 0, either the bitmap file is corrupted
> or you need to upgrade your tools
> 

[snip...]

Bryan
