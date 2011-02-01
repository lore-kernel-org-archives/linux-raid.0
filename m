From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: RAID HDDs spin up sequence
Date: Tue, 1 Feb 2011 12:37:44 -0200
Message-ID: <AANLkTimKD79Yq3zp35YsrAmVu7EXLMPQLH9YojuoTXTf@mail.gmail.com>
References: <20110131201823.GA15704@lazy.lzy>
	<AANLkTinPTaDfVtjMfz7DHUa95cKFF7MZeg=WhuuTnZM8@mail.gmail.com>
	<20110131222348.GA15912@lazy.lzy>
	<9EBB77E762A6744BACE68EDD6A4796990129EC0E@MX31A.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9EBB77E762A6744BACE68EDD6A4796990129EC0E@MX31A.corp.emc.com>
Sender: linux-raid-owner@vger.kernel.org
To: brian.foster@emc.com
Cc: piergiorgio.sartor@nexgo.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

maybe a check inside mdadm code should be implemented

before send read/write command check if device is sleeping,
if yes
if previous devices wakeup command was more than x seconds OR no
device, send a wakeup command

another idea: a fixed delay to wake up, diferent per device, but could
only work when we send(before sleep part of code) to all devices
command at the same time

mdadm should be changed (options be included) and kernel source too

2011/2/1  <brian.foster@emc.com>:
>> -----Original Message-----
>> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
>> owner@vger.kernel.org] On Behalf Of Piergiorgio Sartor
>> Sent: Monday, January 31, 2011 5:24 PM
>> To: Roberto Spadim
>> Cc: Piergiorgio Sartor; linux-raid@vger.kernel.org
>> Subject: Re: RAID HDDs spin up sequence
>>
>> On Mon, Jan 31, 2011 at 07:09:24PM -0200, Roberto Spadim wrote:
>> > you psu must be dimensioned to work with everythink at full work l=
oad
>> > (it=E6=84=80 a real production NAS right?! not a test)
>> > your SAS/IDE/SATA controller and HDD manual should be checked
>> > how hdd wake up? one command (read/write) over sata/sas/ide channe=
l
>> wake it up?
>> > on linux raid we have a read algorithm and a write algorithm
>> > if a raid1 write occur all disks will wake up
>> > if a raid1 (raid0 or another) read occur only the disk will wake u=
p
>> >
>> > but check you SATA/IDE/SATA controller, how it wake up your disk, =
and
>> > how you hdd wake up
>>
>> Hi, thanks for the answer, unfortunately I was
>> hoping to have made myself clear enough.
>>
>> First of all, it is a RAID-6, so let's say that's
>> already decided by requirements. With SATA HDDs.
>>
>> Second, the question was exactly about how the HDDs
>> are waked up. This is a SW issue, trying with normal
>> setups, i.e. a couple of disks, it is possible to
>> send them to sleep (hdparm -y /dev/hdX) and the wake
>> them up by a simple access.
>> I had no opportunity to check this with a RAID-5/6,
>> so I was asking if anyone knows.
>>
>> Finally, in order to be power efficient, the PSU,
>> assuming something like an 80 Plus Gold, should work
>> at not less than 20% of the nominal power, otherwise
>> (according to some reviews), the efficiency drops far
>> below the 80%~90% declared by the 80 Plus standard
>> (which is measured at 20%, 50% and 100% of the maximum
>> specified power).
>> It seem it gets easily around 40%~50%.
>> So, the PSU must be somehow under dimensioned for the
>> spin up of 10 HDDs, which seem to require a possible
>> 30W*10=3D300W (some nasty HDDs seem to require 30W, in
>> this situation) only for the storage.
>>
>> If the HDDs spin up one after the other, then the peak
>> consumption is only 30W, which might allow a lower
>> power PSU, in contrast with the requirement to provide
>> 300W alone for the spin up.
>>
>> So, back to the original question, if a 10 HDDs RAID-6
>> is in standby, how do the single HDD will be waked up,
>> in case of access? Of course, a quite larger access,
>> i.e. some GiB of data.
>
> We have a similar situation with our Iomega NAS products. We had a fa=
irly crude locking mechanism implemented at the SCSI level that suits o=
ur needs to support staggered spin up. As indicated previously, we find=
 that a 1 or 2 second delay between spin ups modulates the current draw=
 enough such that we don't run into problems. We use this in conjunctio=
n with MD without much of a problem.
>
> I'm not sure that the code as implemented is appropriate for mainline=
 inclusion (and I'm not going to post it directly), but FYI the patches=
 are included in the open source tarball that is made available on the =
support section of the iomega.com website (hint: check out the ix12 sup=
port & downloads section).
>
> Brian
>
>>
>> Thanks again,
>>
>> bye,
>>
>> --
>>
>> piergiorgio
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
