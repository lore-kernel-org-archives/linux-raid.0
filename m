From: "fibreraid@gmail.com" <fibreraid@gmail.com>
Subject: Re: md question re: max_hw_sectors_kb
Date: Mon, 30 May 2011 20:06:41 -0700
Message-ID: <BANLkTikQ_9H6xYQTO=2G-O42R1oYe1o11w@mail.gmail.com>
References: <4DC0639E.1070707@sgi.com>
	<yq17ha6z6tu.fsf@sermon.lab.mkp.net>
	<20110510095243.0a23874b@notabene.brown>
	<yq1oc38poej.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq1oc38poej.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: NeilBrown <neilb@suse.de>, Michael Reed <mdr@sgi.com>, linux-raid@vger.kernel.org, Jeremy Higdon <jeremy@sgi.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-raid.ids

Hi Mike,

Thank you for the patch. I've tested it though on 2.6.38 and do not
see any significant change in md RAID 5 write performance compared to
the unpatched kernel. Can you clarify how you may have achieved a
demonstrable improvement?

-Tommy


On Wed, May 11, 2011 at 8:51 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Neil" =3D=3D NeilBrown =A0<neilb@suse.de> writes:
>
> Neil,
>
>>> Your fix is functionally correct. However, another case just popped
>>> up this week where we need to distinguish between stacking driver a=
nd
>>> LLD defaults.
>
> Neil> What case is this?
>
> This particular case involved the need to set different defaults for
> discard depending on whether it was a stacking or a low level driver.
>
>
> Neil> If you have FS -> DM -> MD, then any change that MD makes to
> Neil> max_hw_sectors_kb will not be visible to the FS. =A0So adding a=
nd
> Neil> activating a hot spare with smaller max_hw_sectors_kb cause cau=
se
> Neil> it to receive requests that are too big.
>
> Yeah, this issue pops up occasionally. Alasdair and I were discussing=
 it
> just a couple of weeks ago.
>
>
> Neil> So we really need a propery resolution to this problem first.
> Neil> i.e. A way for 'dm' to notice when 'md' changes its parameters =
-
> Neil> or in general any stacking deivce to find out when an underlyin=
g
> Neil> device changes in any way.
>
> Neil> I would implement this by having blkdev_get{,_by_path,_by_dev}
> Neil> take an extra arg which is a pointer to a struct of functions. =
=A0In
> Neil> the first instance there would be just one which tells the clai=
mer
> Neil> that something in queue.limits has changed. =A0Later we could a=
dd
> Neil> other calls to help with size changes.
>
> I agree we need a way to propagate queue limit and capacity changes u=
p
> the stack. I'll put in on my todo list.
>
> --
> Martin K. Petersen =A0 =A0 =A0Oracle Linux Engineering
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
