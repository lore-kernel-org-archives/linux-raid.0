From: Turbo Fredriksson <turbo@bayour.com>
Subject: Re: Which (physical) disk is broken?
Date: Mon, 27 Dec 2004 13:35:28 +0100
Message-ID: <87wtv3zzov.fsf@pumba.bayour.com>
References: <200412241714.iBOHED921515@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200412241714.iBOHED921515@www.watkins-home.com> (bugzilla@watkins-home.com's
 message of "Fri, 24 Dec 2004 12:14:07 -0500")
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Guy" == Guy  <bugzilla@watkins-home.com> writes:

    Guy> The info is in the superblock.  But if the disk has failed,
    Guy> you may not be able to read the superblock.

It's not THAT failed. It just have way to many bad blocks to be useful
so I took it out of service (but, unfortunately not from the machine -
I'll remember to do that next time :)...

To bad there's no 'eject' command for disks :) That would be quite funny,
shooting my colleague(s) with disks from the rack :)

    Guy> Did you say you don't use superblocks?  I guess you better
    Guy> keep a paper trail!

I do, but I always forget to update it... 

    Guy> You said: "when persistent super blocks is used (which I
    Guy> don't)."

I didn't say I don't use 'super blocks' I said 'PERSISTENT super blocks'

    Guy> But the output from mdadm said: "Persistence : Superblock is
    Guy> persistent"

He, yeah. Sorry. I saw that in the same instant it was sent, but to late
to cancel...


I've had quite a lot of time thinking about this, and I am now QUITE
sure that I created the array with 'missing' on the place where this
disk should have been.... I can VAGLEY remember that that disk kept
failing the array when I built the machine/array initially. But I'm not
sure it was THAT disk, or some other (I have a bunch of these disks
that "don't quite work")...

Thanx for all the help everyone. But seeing the thread 
'mdadm -D /dev/md3: 1  0  0  0  sync ???' on this list, leads me to
believe I'm not THAT far out in wanting some better information
on what disk is what...
-- 
Khaddafi Marxist Legion of Doom 767 747 domestic disruption Peking
subway nitrate Uzi Kennedy explosion Rule Psix NORAD Honduras
[See http://www.aclu.org/echelonwatch/index.html for more about this]
