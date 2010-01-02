From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Size limitation?
Date: Fri, 1 Jan 2010 16:46:56 -0800
Message-ID: <4877c76c1001011646y6e5826ddx5b360e2cfdb2e28a@mail.gmail.com>
References: <201001011457.24334.mmclagan@invlogic.com>
	 <4B3E85B3.6080607@matfyz.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B3E85B3.6080607@matfyz.cz>
Sender: linux-raid-owner@vger.kernel.org
To: Zdenek Behan <rain@matfyz.cz>
Cc: mmclagan+reply@invlogic.com, Michael McLagan <mmclagan@invlogic.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jan 1, 2010 at 3:30 PM, Zdenek Behan <rain@matfyz.cz> wrote:
> On 01/01/2010 08:57 PM, Michael McLagan wrote:
>> =A0 =A0I'm trying to set up a large array but isn't working. =A0I tr=
ied
>> Googling size limits, etc and came up empty.
>>
>> The problem is that with 10 drives (300GB SCSI), the array is coming=
 up
>> with 500GB of space?!? =A0I did an experiment and when the array siz=
e
>> exceeds 2TB, it fails/wraps?
>>
> Just curious, did you compile your kernel with LBD (Large Block Devic=
e)
> support?
>
>
> Zdenek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

I couldn't find it in my config, so I googled:
http://cateee.net/lkddb/web-lkddb/LBD.html  That does look like the
most likely problem.

If at all possible try to get a good dmesg capture of a new kernel,
you might want to explore using netconsole to log via UDP to a remote
system.  Chances are good it's just some chipset/driver issue; I
remember having problems with a lack of timer for some boards; either
forcing it to use the older style timer or using a patched bios which
properly setup the HPET (timer) resolved the issue.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
