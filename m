From: Veedar Hokstadt <veedar@gmail.com>
Subject: Re: Recovery possible after partial reshape failure?
Date: Mon, 15 Jul 2013 18:08:18 -0400
Message-ID: <CANb3qHdrTWp4-SA9is+f986wXBp9HCRfoHj23Xc18EpkWLPEOw@mail.gmail.com>
References: <CANb3qHfPELcUdFeAOzRaZNE2d4ZAS=8ZHNc6he0qbcRAibpTNA@mail.gmail.com>
	<CE077E5D.139E8%sam@bingner.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CE077E5D.139E8%sam@bingner.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sam Bingner <sam@bingner.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks Sam. I can confirm that the mdadm --examine info I posted is cor=
rect.

I'm guessing the answer is to somehow "fix" sdf so that mdadm will
accept it and use it to assemble the RAID.

On Sun, Jul 14, 2013 at 4:09 AM, Sam Bingner <sam@bingner.com> wrote:
> On 7/13/13 10:01 AM, "Veedar Hokstadt" <veedar@gmail.com> wrote:
>
>>Hello, Please consider the following RAID5 recovery attempt after a
>>failed partial reshape.
>>Copy-on-write devices were created to protect original drives.
>>Any assistance on how to reassemble would be most welcome.
>>
>>...Operating environment is from a systemrescuecd...
>>% mdadm -V
>>mdadm - v3.1.4 - 31st August 2010
>>% /usr/local/sbin/mdadm -V    <<<<<< compiled latest by hand
>>mdadm - v3.2.6 - 25th October 2012
>>% uname -a
>>Linux dallas 3.2.33-std311-amd64 #2 SMP Wed Oct 31 07:31:30 UTC 2012
>>x86_64 Intel(R) Core(TM) i7-2600K CPU @ 3.40GHz GenuineIntel GNU/Linu=
x
>>
>>...Drive /dev/mapper/cow_sdc1 appears damaged and goes offline
>>sporadically, so I'm trying to reassemble with out sdc1...
>>...In any case sdc1 is out of sync with the other drives and it's
>>reshape pos'n is at zero...
>>...Also /usb/foo is an empty file...
>
>
> sdc and  sdf's event counts are both 2 events higher than the other
> devices=C5=A0 I suspect this is causing issues because sdf's event co=
unt and
> update time is higher than the other good devices, but I'm not sure h=
ow to
> correct it.   I wanted to see if you can verify that the original sdf=
 also
> has this problem (updated later than all the other devices with an
> incremented event count)
>
> I'm sure somebody with more knowledge than I will be able to give you=
 more
> information.
>
> Sam
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
