From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: non-fresh data unavailable bug
Date: Thu, 14 Jan 2010 11:24:03 -0800
Message-ID: <4877c76c1001141124m1d3fcfcdmffc3df97d1b504a@mail.gmail.com>
References: <hinc60$fnh$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <hinc60$fnh$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Brett Russ <bruss@netezza.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jan 14, 2010 at 7:10 AM, Brett Russ <bruss@netezza.com> wrote:
> Slightly related to my last message here Re:non-fresh behavior, we ha=
ve seen
> cases where the following happens:
> * healthy 2 disk raid1 (disks A & B) incurs a problem with disk B
> * disk B is removed, unit is now degraded
> * replacement disk C is added; recovery from A to C begins
> * during recovery, disk A incurs a brief lapse in connectivity. =A0At=
 this
> point C is still up yet only has a partial copy of the data.
> * a subsequent assemble operation on the raid1 results in disk A bein=
g
> kicked out as non-fresh, yet C is allowed in.
>
> This presents quite a data-unavailability problem and basically requi=
res
> recognizing the situation and hand assembling the array with disk A (=
only)
> first, then adding C back in. =A0Unfortunately this situation is hard=
 to
> reproduce and we don't have a dump of the 'mdadm --examine' output fo=
r it
> yet.
>
> Any thoughts on this while we try to get a better reproduction case?
>
> Thanks,
> Brett
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

I believe the desired and logical behavior here is to refuse running
an incomplete array unless explicitly forced to do so.  Incremental
assembly might be what you're seeing.

The only way to access the data from those devices, presuming that
without the device that had the hiccup your array is incomplete, would
be to force assembly with the older device included and hope.  I very
much recommend running it read-only until you can determine which
assembly pattern produces the most viable results.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
