From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Device role question
Date: Fri, 26 Feb 2010 21:56:02 -0800
Message-ID: <4877c76c1002262156k6675877am79a7da9b63446dc7@mail.gmail.com>
References: <20100226142331.GA2328@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100226142331.GA2328@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Feb 26, 2010 at 6:23 AM, Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:
> Hi all,
>
> checking randomly the component of some RAID-10 arrays
> (two disks each), with "mdadm -E /dev/sdXY", I noticed
> the following.
>
> There is an entry reported, called "Device Role".
>
> On one array, the components are defined, respectively, as:
>
> Active device 0
> Active device 1
>
> On another two arrays, it's a bit different.
>
> Active device 0
> spare
>
> Why is it "spare" (all are RAID-10 f2)?
>
> Does it make any difference one or the other role, in
> this type of RAID?
>
> On the other hand, "mdadm -D /dev/mdX" does not seem
> to give any hint on the different roles.
>
> Thanks,
>
> bye,
>
> --
>
> piergiorgio
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Spare should mean that it is not currently a synced member of the
array; in other words a hot-spare.  As I recall raid10 cannot
currently be grown (or /may/ only be grown with VERY recent
tools+kernels); did you maybe create a single device raid10 and try to
grow it?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
