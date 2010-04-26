From: Andrew Klaassen <clawsoon@yahoo.com>
Subject: Re: RAID10 - Ensure mirrors aren't on same JBOD
Date: Mon, 26 Apr 2010 13:20:20 -0700 (PDT)
Message-ID: <444163.38039.qm@web65406.mail.ac4.yahoo.com>
References: <u2r4877c76c1004261258t317657f7radd2d52f2fac3cdf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <u2r4877c76c1004261258t317657f7radd2d52f2fac3cdf@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--- On Mon, 4/26/10, Michael Evans <mjevans1983@gmail.com> wrote:

> Or write your own program to generate mdadm headers on
> uninitialized devices.=A0 Or if it's just a one time thing,
> write the headers, stop the array, make sure it says what
> you want, and then force a resync before writing any data.

So the headers determine which disks mirror which disks?

Does that mean that if I ordered my disks correctly on the --create com=
mandline, I could depend on all of the data being ordered the way that =
some of the data is?  I.e. if I figured out which two disks were mirror=
ing each other, I would know that they'd always mirror each other as lo=
ng as I didn't update the array metadata in any way?

Thanks.

Andrew





--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
