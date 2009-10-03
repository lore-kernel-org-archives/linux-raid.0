From: David Rees <drees76@gmail.com>
Subject: Re: RAID10 - migrating disks without failing/degrading array?
Date: Fri, 2 Oct 2009 19:53:27 -0700
Message-ID: <72dbd3150910021953l67ecd8ffk3d80d2a3699b04c7@mail.gmail.com>
References: <72dbd3150910021122r474c43f6m2f1d953b5af9c3e0@mail.gmail.com>
	<7d86ddb90910021836h537e2af6h552b7c89af37d612@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7d86ddb90910021836h537e2af6h552b7c89af37d612@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ryan Wagoner <rswagoner@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

(Re-adding linux-raid to CC)

On Fri, Oct 2, 2009 at 6:36 PM, Ryan Wagoner <rswagoner@gmail.com> wrot=
e:
> On Fri, Oct 2, 2009 at 2:22 PM, David Rees <drees76@gmail.com> wrote:
>> It seems like I should be able to add a drive as a directly
>> replacement for one of the drives I'm pulling out (so I temporarily
>> end up with 3-copies of that chunk instead of 2) until I pull
>> fail/remove the older disk. =A0If I was using RAID0 striped over RAI=
D1
>> mirrors, for example, I know this is possible.
>>
>> Is this possible to do with RAID10?
>
> You could stop the array and use dd to copy the old disks to the new
> ones. Then just start up the array on the new disks.

Yeah, that would work, but the goal is to do the migration without any =
downtime.

eSATA hot-swap even in inexpensive enclosures works pretty well these
days.  There are slight hiccups as the drives get rescanned, but it's
not too noticable.

-Dave
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
