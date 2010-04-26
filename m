From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: RAID10 - Ensure mirrors aren't on same JBOD
Date: Mon, 26 Apr 2010 14:30:50 -0700
Message-ID: <o2o4877c76c1004261430r4e57b2a1hf1aa3dddb6b880b0@mail.gmail.com>
References: <u2r4877c76c1004261258t317657f7radd2d52f2fac3cdf@mail.gmail.com>
	<444163.38039.qm@web65406.mail.ac4.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <444163.38039.qm@web65406.mail.ac4.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Klaassen <clawsoon@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 26, 2010 at 1:20 PM, Andrew Klaassen <clawsoon@yahoo.com> w=
rote:
> --- On Mon, 4/26/10, Michael Evans <mjevans1983@gmail.com> wrote:
>
>> Or write your own program to generate mdadm headers on
>> uninitialized devices.=A0 Or if it's just a one time thing,
>> write the headers, stop the array, make sure it says what
>> you want, and then force a resync before writing any data.
>
> So the headers determine which disks mirror which disks?
>
> Does that mean that if I ordered my disks correctly on the --create c=
ommandline, I could depend on all of the data being ordered the way tha=
t some of the data is? =A0I.e. if I figured out which two disks were mi=
rroring each other, I would know that they'd always mirror each other a=
s long as I didn't update the array metadata in any way?
>
> Thanks.
>
> Andrew
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Logically that is a valid assumption.  The meta-data identifies the
devices and describes the device storage layout.  If you pop in any
older metadata devices with a newer kernel and/or version of mdadm the
old layout must still be supported so that the data can be accessed.
Why would anyone want to bother moving already written data without a
reshape command of some kind?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
