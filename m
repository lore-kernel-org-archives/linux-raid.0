From: "Majed B." <majedb@gmail.com>
Subject: Re: 2 Disks Jumped Out While Reshaping RAID5
Date: Mon, 7 Sep 2009 03:44:11 +0300
Message-ID: <70ed7c3e0909061744h52b9fe77o5dac310e983d2252@mail.gmail.com>
References: <70ed7c3e0909051322l7cf66158lbbc8a5dd2cc18b8b@mail.gmail.com>
	<a6dfa0829c75cc81fd4482bb344bbff2.squirrel@neil.brown.name>
	<70ed7c3e0909060300la51bec3ke51c35373b2ee1fc@mail.gmail.com>
	<19108.19281.495223.465327@notabene.brown> <70ed7c3e0909061655u344c2c6dt1939f85b10f49fa0@mail.gmail.com>
	<70ed7c3e0909061701i4190642ew66827a3aca3c277e@mail.gmail.com>
	<3b8699b874ea2645458f9295812270a5.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3b8699b874ea2645458f9295812270a5.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks a lot Neil for your help :)

kernel logs showed a SATA link error for sdg. I double checked the
cables and they were more than fine and the array was running for
weeks before I did the reshaping and no errors were reported before
the reshaping process.

I'm using an MSI motherboard (MS-7514) and been having random issues
with it since reaching 6 disks. I've recently ordered an EVGA
motherboard and if things turn to be stable on it, I'll ditch MSI for
good.

Throughout searching for the past 6 days, I noticed people complaining
from acpi and apic causing issues, so I turned them off and will see
how things turn out.

These are the hard disks I'm using:

root@Adam:~# hddtemp /dev/sd[a-h]
/dev/sda: WDC WD10EACS-00D6B1: 26=C2=B0C
/dev/sdb: WDC WD10EACS-00D6B1: 28=C2=B0C
/dev/sdc: WDC WD10EACS-00ZJB0: 29=C2=B0C
/dev/sdd: WDC WD10EADS-65L5B1: 27=C2=B0C
/dev/sde: WDC WD10EADS-65L5B1: 28=C2=B0C
/dev/sdf: MAXTOR STM31000340AS: 28=C2=B0C
/dev/sdg: WDC WD10EACS-00ZJB0: 26=C2=B0C
/dev/sdh: WDC WD10EADS-00L5B1: 25=C2=B0C
/dev/sdi: Hitachi HDS721680PLAT80: 32=C2=B0C

(sdi is the OS disk)

Neil, do you suggest any certain test/stress-tests to put sdg through?

I'll force a couple of short and long smartd tests on it, and have dd
read the whole disk a couple of times to make sure all sectors are
read properly. Is that sufficient?

Thank you again.

On Mon, Sep 7, 2009 at 3:31 AM, NeilBrown<neilb@suse.de> wrote:
> On Mon, September 7, 2009 10:01 am, Majed B. wrote:
>> I have installed mdadm 3.0 and ran -Af and now it's continuing
>> reshaping!!!
>
> Excellent.
>
> Based on the --examine info you provided it appears that
> /dev/sdg1 reported an error at about 00:10:39 on Wednesday morning
> and was evicted from the array. =C2=A0Reshape was up to 2435GB (37%) =
at
> that point.
> Reshape continued until 06:40:04 that morning at which point it
> had reached 3201GB (49%). =C2=A0At that point /dev/sdf1 seems to have
> reported an error so the whole array went off line.
>
> When you reassembled with mdadm-3.0 and --force, it excluded sdg1
> as that was the oldest, and marked sdf1 as up-to-date, and continued.
>
> The reshape processes will have redone the last few chunks so all
> the data will have been properly relocated.
>
> As all the superblocks report that the array was "State : clean",
> you can be quite sure that all your data is safe (if they were
> "State : active" there would be a small chance some a block or two
> was corrupted and a fsck etc would be advised).
>
> It wouldn't hurt to examine your kernel logs to see what sort of
> error was tiggered at those two times in case there might be a need
> to replace a device.
>
>
>
>
>> sdg1 is not in the list. Is that correct?! =C2=A0sdg1 was one of the
>> array's disks before expanding. So I guess now the array is degraded
>> yet is reshaping as if it had 8 disks, correct?
>
> Yes, that is correct.
> It may be that sdg has a transient error, or it may have a serious
> media or other error. =C2=A0You should convince yourself that it is w=
orking
> reliably before adding it back in to the array.
>
>
>
>>
>> So after the reshaping process is over, I can add sdg1 again and it
>> will resync properly, right?
>
> Yes it will, providing no write-errors occur while writing data to it=
=2E
>
> NeilBrown
>
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
