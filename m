From: Phil Turmel <philip@turmel.org>
Subject: Re: problem with raid after reboot
Date: Mon, 10 Dec 2012 08:58:33 -0500
Message-ID: <50C5EA89.40804@turmel.org>
References: <CADzS=aqXh08P+ujEoJPMBxPiZ-PeEdk3x3iRW1ymAvhtpZcDmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADzS=aqXh08P+ujEoJPMBxPiZ-PeEdk3x3iRW1ymAvhtpZcDmA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: bobzer <bobzer@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Mathieu,

On 12/09/2012 11:13 PM, bobzer wrote:
> hi had to reboot my raid 5 server. but now it doesnt't want to
> reassemble correctly
> 
> i have a raid 5 of 3 disk and a lvm on top of that. i know my data are
> there but i'm afraid of enter the dead command :-)
> 
> so here is the information about my raid, if someone could help or
> explain me something or just give a clue to follow.
> i remember that, this already happend to me ... exactly the same but i
> don't remember how i did (promes that this time right everything down)
> because it's already happend i'm afraid there is a bigger problem in my raid...
> 
> help me please :-)

It looks like the superblocks didn't get updated together due to your
improper reboot.  (Event counts don't match.)

I suggest you stop the array and reassemble with "--force", like so:

mdadm --stop /dev/md0
mdadm --assemble --force /dev/md0 /dev/sd[bcd]1

The "--force" option will instruct mdadm to ignore the event count mismatch.

You probably want to investigate why your array wasn't properly stopped
during shutdown.

HTH,

Phil

