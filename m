From: CoolCold <coolthecold@gmail.com>
Subject: Re: md lock issue, I suppose
Date: Fri, 25 Jun 2010 16:39:05 +0400
Message-ID: <AANLkTilD8V_NSMrRCcpYFIt_AfXhqjNP6PWxd-JdK_h_@mail.gmail.com>
References: <20100621204208.GA29830@lazy.lzy>
	<4C1FD4CF.20109@stud.tu-ilmenau.de>
	<20100621212521.GA31833@lazy.lzy>
	<20100622082233.2015caee@notabene.brown>
	<20100624180727.GA9038@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100624180727.GA9038@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Neil Brown <neilb@suse.de>, st0ff@npl.de, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

"partprobe" command helps me in cases i'm adding partitions on device
which is already partitions which are mounted

On Thu, Jun 24, 2010 at 10:07 PM, Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:
> Hi,
>
> thanks for the hint, basically that exactly
> what was needed, i.e. informing the kernel
> about the new partition.
>
> The only different with your suggestion was
> to use "addpart", instead of "partx".
>
> Thanks again,
>
> bye,
>
> pg
>
> On Tue, Jun 22, 2010 at 08:22:33AM +1000, Neil Brown wrote:
>> On Mon, 21 Jun 2010 23:25:21 +0200
>> Piergiorgio Sartor <piergiorgio.sartor@nexgo.de> wrote:
>>
>> > Any other suggestions or ideas?
>> >
>>
>> You cannot use the BLKRRPART ioctl while any partition of the device=
 is open.
>> However you can use BLKPG_ADD_PARTITION to add a new partition provi=
ding it
>> doesn't overlap any existing partition.
>> Unfortunately parted doesn't use this ioctl, nor am I aware of anyth=
ing which
>> does. (Google suggests something called DeviceKit does, but I know n=
othing
>> about that).
>> You could write a program which reads the the partition table and tr=
ies to
>> add each partition individually. =A0Some might fail but others might=
 succeed.
>> ... or maybe you don't need to- 'partx' in util-linux-ng seems to do=
 what you
>> want.
>>
>> NeilBrown
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
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



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
