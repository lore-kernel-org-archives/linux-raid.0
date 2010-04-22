From: Simon Matthews <simon.d.matthews@gmail.com>
Subject: Re: Use of WD20EARS with MDADM
Date: Thu, 22 Apr 2010 11:16:38 -0700
Message-ID: <h2h40b437201004221116yfc315182v92ce6deb0e4379f7@mail.gmail.com>
References: <4BAB8D41.4010801@gmail.com>
	 <y2x5bdc1c8b1004211036ra8e10a43kc1a13c2b374a5f7b@mail.gmail.com>
	 <4BCF4693.3020101@buttersideup.com>
	 <201004221913.50692.eye.of.the.8eholder@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201004221913.50692.eye.of.the.8eholder@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Khelben Blackstaff <eye.of.the.8eholder@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Apr 22, 2010 at 9:13 AM, Khelben Blackstaff
<eye.of.the.8eholder@gmail.com> wrote:
>> I believe that these disks only come in the "green" variety. =A0I re=
cently
>> picked up a 1.5 tb version for testing and cheap bulk storage, and I
>> would not suggest using them in a raid array because the green drive=
s
>> firmware automatically parks the head after 8 seconds of inactivity =
and
>> reduces the rpm of the disk. =A0The constant parking can quickly wea=
r out
>> the head under high use and there is no way to disable this "feature=
".
>
> As previously mentioned wdidle utility can disable the head unloading=
=2E
>
>> The specifications say it's good for 300,000 cycles, so do the
>> math... getting 5 unloads per minute would lead to probable failure
>> after 41 days. =A0Granted that is about worst case, but still someth=
ing to
>> watch out for. =A0In order to make it the entire 3 year warranty per=
iod,
>> you need to stay under 11.4 unloads per hour. =A0If you have very li=
ttle
>> IO activity, or VERY MUCH, then this is entirely possible, but more
>> moderate loads in the middle have been observed to cause hundreds of
>> unloads per hour.
>
> WD mentions in the customer help (Answer ID 5357) that these newer dr=
ives
> were validated to 1M load/unload cycles and not 300K.
>
>>
>> If you want to fix it, then wdidle3.exe worked for me. =A0Search for=
:
>>
>> wdidle3_1_00.zip
>>

I just looked at a WD green drive that was in a RAID1 set for several
months. The drive is an older model -- WD10EADS, but I think similar.
I did not use the widdle utility and the S.M.A.R.T. data reports a
load cycle count of 42. The RAID set held user directories, so it was
either under constant access (daytime) or not at all (nighttime, apart
from during backups).

Simon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
