From: Richard Herd <2001oddity@gmail.com>
Subject: Re: Please Help! RAID5 -> 6 reshapre gone bad
Date: Tue, 7 Feb 2012 14:19:06 +1100
Message-ID: <CAOANJV_jC_jvUuNuB96ARwJDyg1KAR1ind6uvjTFb4pfuyaHag@mail.gmail.com>
References: <CAOANJV-V8ZTXBvQxxMnEnv24p8A-fAas-6x65ifW5yp35ZqHnA@mail.gmail.com>
	<20120207133947.5c4b9a59@notabene.brown>
	<20120207141023.22cce706@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120207141023.22cce706@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

Thanks.

=46YI, I've cloned your git repo and compiled and tried using your code=
=2E
 Unfortunately everything looks the same as below (exactly same
output, exactly same dmesg - still wants to kick non-fresh sdc from
the array at assemble).

Cheers

Rich

On Tue, Feb 7, 2012 at 2:10 PM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 7 Feb 2012 13:39:47 +1100 NeilBrown <neilb@suse.de> wrote:
>
>> > I tried to assembe the array, to see if it would continue the resh=
ape:
>> >
>> > root@raven:/# mdadm -Avv --backup-file=3D/usb/md0.backup /dev/md0
>> > /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sdf1 /dev/sdg1
>> >
>> > Unfortunately mdadm had decided that the backup-file was out of da=
te
>> > (timestamps didn't match) and was erroring with: Failed to restore
>> > critical section for reshape, sorry..
>> >
>> > Chances are things were in such a mess that backup file wasn't goi=
ng
>> > to be used anyway, so I blocked the timestamp check with: export
>> > MDADM_GROW_ALLOW_OLD=3D1
>> >
>> > That allowed me to assemble the array, but not run it as there wer=
e
>> > not enough disks to start it.
>>
>> You probably just need to add "--force" to the assemble line.
>> So stop the array (mdamd -S /dev/md0) and assemble again with --forc=
e as well
>> as the other options.... or maybe don't.
>>
>> I just tested that and I didn't do what it should. =A0I've hacked th=
e code a
>> bit and can see what the problem is and think I can fix it.
>>
>> So leave it a bit. =A0I'll let you know when you should =A0grab my l=
atest code
>> and try that.
>
> Ok, that should work..
> If you:
>
> =A0git clone git://neil.brown.name/mdadm
> =A0cd mdadm
> =A0make
> =A0export MDADM_GROW_ALLOW_OLD=3D1
> =A0./mdadm -Avv --backup-file=3D/usb/md0.backup /dev/md0 ..list.of.de=
vices.. --force
>
>
> it should restart the grow. =A0Once device will be left failed. =A0If=
 you think
> it is usable then when the grow completes you can add it back in.
>
> If you get another failure it will die again and you'll have to resta=
rt it.
>
> If you get a persistent failure, you might be out of luck.
>
> Please let me know how it goes.
>
> NeilBrown
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
