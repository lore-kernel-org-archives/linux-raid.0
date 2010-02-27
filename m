From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Device role question
Date: Sat, 27 Feb 2010 00:55:30 -0800
Message-ID: <4877c76c1002270055o2ebc038ag52e0b9a8f5b407d@mail.gmail.com>
References: <20100226142331.GA2328@lazy.lzy>
	 <4877c76c1002262156k6675877am79a7da9b63446dc7@mail.gmail.com>
	 <20100227080845.GA2287@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100227080845.GA2287@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Feb 27, 2010 at 12:08 AM, Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:
> Hi,
>
>> Spare should mean that it is not currently a synced member of the
>> array; in other words a hot-spare. =A0As I recall raid10 cannot
>> currently be grown (or /may/ only be grown with VERY recent
>> tools+kernels); did you maybe create a single device raid10 and try =
to
>> grow it?
>
> uhm, well, not really, but almost.
>
> If I remember correctly, at least one of the arrays
> with "spare", was created with missing disk, added
> then later.
>
> BTW, I also notice another array, still RAID-10,
> where both the disks have "spare" role...
>
> Thanks,
>
> bye,
>
> --
>
> piergiorgio
>

Ok, please run this for each disk in the array:

mdadm --examine /dev/(DEVICE)

The output would be most readable if you did each array's devices in
order, and you can list them on the same command (- - examine takes
multiple inputs)

If you still think the situation isn't as I described above, post the r=
esults.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
