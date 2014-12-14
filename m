From: Phil Turmel <philip@turmel.org>
Subject: Re: Lost raid 5 volume
Date: Sun, 14 Dec 2014 11:23:30 -0500
Message-ID: <548DB982.7010503@turmel.org>
References: <CADhQzuraHNZ1MaMw4OP0-3+vxRcB_TAN-_R2_eaTOQcEfUv8+w@mail.gmail.com>	<CAB_L8sZUdZkLRPQXS+ANam=k4Tvjynkh8UzgL5WXE3qBwYUK6Q@mail.gmail.com> <CADhQzuo57BoMT_fLVHd=ufGR6ztSFaRqsRLZtFSwvii+YzAcLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADhQzuo57BoMT_fLVHd=ufGR6ztSFaRqsRLZtFSwvii+YzAcLQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Neil ." <neil.perrie@gmail.com>, Emery Guevremont <emery.guevremont@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning Neil,

[Etiquette on kernel.org is to trim replies and either bottom-post or
interleave.]

On 12/13/2014 11:30 PM, Neil . wrote:
> smartctl says Overall health...: passed for all drives.

This is good, but not relevant.  Lots of desktop drives will report this
even though they are part of the problem.  Please show the complete
output of "smartctl -x" for the two troublesome drives.  Maybe also for
the other two.

>     Update Time : Sat Dec  6 14:00:02 2014
>          Events : 3

>     Update Time : Sat Dec  6 14:00:02 2014
>          Events : 3

>     Update Time : Sun Dec  7 11:18:06 2014
>          Events : 8

>     Update Time : Sun Dec  7 11:18:06 2014
>          Events : 8

This looks strange.  It suggests that the two drives failed well before
your reboot.  If you have dmesg from Saturday afternoon, that might be
enlightening.

However, as a raid 5, you are stuck unless you include at least one of
the two stale drives.  The correct tool for this is forced assembly:

mdadm --assemble --force --verbose /dev/mdX /dev/sd[abcd]2

If it fails, show its output.

Whether it fails or not, you need to investigate why the drives were
dropped.  Simultaneous drops suggest a hardware problem.

Phil
