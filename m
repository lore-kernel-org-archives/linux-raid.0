From: CoolCold <coolthecold@gmail.com>
Subject: Re: XFS on top RAID10 with odd drives count and 2 near copies
Date: Mon, 13 Feb 2012 13:49:58 +0400
Message-ID: <CAGqmV7p9QhyaH-k2Xw7jhoxEEkwwJ4wF1AqqiULfZvL+-MdZ0g@mail.gmail.com>
References: <CAGqmV7o7AQFY1K-1JLDk02Cv6GpAUQFjiSdM2Wbdbu6Zh_t0Wg@mail.gmail.com>
	<4F35E925.6000003@hardwarefreak.com>
	<CAGqmV7rBa39U-RWkzH-cTci1pNrrY1sfS=DkyK1wHE80bMt6qA@mail.gmail.com>
	<4F38CFB5.3090102@westcontrol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F38CFB5.3090102@westcontrol.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: stan@hardwarefreak.com, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Feb 13, 2012 at 12:54 PM, David Brown <david@westcontrol.com> w=
rote:
> On 12/02/2012 21:16, CoolCold wrote:
>>
>> First of all, Stan, thanks for such detailed answer, I greatly appre=
ciate
>> this!
>>
>> On Sat, Feb 11, 2012 at 8:05 AM, Stan Hoeppner<stan@hardwarefreak.co=
m>
>> =A0wrote:
>>>
>>> On 2/10/2012 9:17 AM, CoolCold wrote:
>>>>
>>>> I've got server with 7 SATA drives ( Hetzner's XS13 to be precise =
)
>>>> and created mdadm's raid10 with two near copies, then put LVM on i=
t.
>>>> Now I'm planning to create xfs filesystem, but a bit confused abou=
t
>>>> stripe width/stripe unit values.
>>>
>>>
>>> Why use LVM at all? =A0Snapshots? =A0The XS13 has no option for mor=
e drives
>>> so it can't be for expansion flexibility. =A0If you don't 'need' LV=
M don't
>>> use it. =A0It unnecessarily complicates your setup and can degrade
>>> performance.
>>
>> There are several reasons for this - 1) I've made decision to use LM=
V
>> for all "data" volumes (those are except /, /boot, /home , etc) =A02=
)
>> there will be mysql database which will need backups with snapshots =
3)
>> I often have several ( 0-3 ) virtual environments (OpenVZ based) whi=
ch
>> are living on ext3/ext4 (because of extensive metadata updates on xf=
s
>> makes it the whole machine slow) filesystem and different LV because
>> of this.
>>
>
> This is a bit off-topic, but do you know of any way to get OpenVZ run=
ning on
> a kernel newer than 2.6.32? =A0One important feature in 2.6.33 is mer=
geable
> LVM snapshots, which would be particularly useful for OpenVZ, such as=
 when
> updating, upgrading or otherwise changing a virtual machine. =A0With =
mergeable
> snapshots you could take a snapshot, apply the changes to the snapsho=
t, and
> if it works you merge them back into the main logical partition.
No, I do not know such solutions except _may be_ using RHEL
(Centos/SL) kernels as OpenVZ team does patches for RHEL kernels as
primary targets and RH may backport some features into their .32
kernel. So if RHEL will/does have mergable LVM snapshots, then you
will need to wait some time and OpenVZ featured kernels will have this
too.

>
> mvh.,
>
> David
>



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
