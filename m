From: Chris Murphy <lists@colorremedies.com>
Subject: Re: RAID6 questions (mdadm 3.2.6/3.3.x)
Date: Fri, 11 Jul 2014 21:46:17 -0600
Message-ID: <D7AA36E1-683F-4E39-87C1-8089EA968E30@colorremedies.com>
References: <53C06815.2020302@dobrotescu.ca> <B953BC37-3769-4D9A-97FF-5EFE7C59EEA4@colorremedies.com> <53C0A994.1050508@dobrotescu.ca>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53C0A994.1050508@dobrotescu.ca>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jul 11, 2014, at 9:20 PM, Vlad Dobrotescu <vlad@dobrotescu.ca> wrote=
:

> On 11/07/2014 21:09, Chris Murphy wrote:
>> On Jul 11, 2014, at 4:41 PM, Vlad Dobrotescu<vlad@dobrotescu.ca>  wr=
ote:
>>> 6. mdadm on top of LVM2 LGs (not the other way around): would there=
 be any issues or performance penalties?
>> You're not assured what PV the LV's are located on. So those 6 LVs y=
ou're using as md members might not be on six physical devices. One dri=
ve dies, you can lose the whole array. You're better off using LVM raid=
, or doing things conventionally by first creating the md raid set and =
then making the md logical device a PV.
> Thanks for the advice, it makes a lot of sense. However, this questio=
n wasn't focused on the RAID6 itself, but related to some fancy (crazy?=
) mirroring scheme for the Linux partition I was considering: take a LV=
 chunk from the VG that sits on the RAID6 and mirror (md RAID1) it with=
 a partition from the SSD I'll be using for keeping the ext4 journal fo=
r the big data partition.

Sounds a bit nutty, no offense. It's complicated, non-standard, and the=
refore at high risk of user induced data loss.

It's basically raid61, which tells me you want the data always for sure=
 always available. Because raid61 is about uptime. The problem is, you'=
re not going to get that because you've overbuilt the storage stack and=
 haven't considered (or mentioned) other fail points like the network, =
the power supply, power itself. So it just sounds wrongly overbuilt bec=
ause the data can't possibly require this kind of uptime, chances are y=
ou're confusing raid with back ups. If the data is both important and i=
t really needs to be available, build yourself a gluster cluster.

> In this way I can have a functional OS even if I take all the RAID6 d=
isks offline. Of course, this can be achieved in other ways as well.

Well if everything you care about on this raid6 fits on an SSD partitio=
n, why don't you just set up an hourly rsync to the raid6 and use the S=
SD volume for live work? And then if you accidentally delete a file or =
crash when writing to the SSD chances are the states of the raid6 LV an=
d the SSD volume are different and one is recoverable. If you raid1 the=
m, any accidents affect both and you're hosed.

>=20
> Anyhow, do you have any estimation of the speed penalty when overlayi=
ng such layers (md-md, md-lvm, =85)?

No. But what you're talking about is md raid6> lv > md raid1, so three =
layers.


Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
