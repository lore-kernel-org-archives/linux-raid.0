From: Doug Ledford <dledford@redhat.com>
Subject: Re: RAID 1 using SSD and 2 HDD
Date: Thu, 28 Jul 2011 14:32:56 -0400
Message-ID: <4E31AB58.3030206@redhat.com>
References: <4E25C9BA.1060401@dodtsair.com> <CABYL=TppzPDszVp3cr0DnuVDAg3Hjq2dvZyP0CYEz2x3H2ZjZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABYL=TppzPDszVp3cr0DnuVDAg3Hjq2dvZyP0CYEz2x3H2ZjZQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Mike Power <mpower@dodtsair.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/19/2011 02:27 PM, Roberto Spadim wrote:
> no this not work very fast...
> use bcache  or other similar ssd+harddisk cache solution (facebook
> have one solution i don=B4t remember the name)
> mixing ssd and hdd are a big problem, since write speed is the slowes=
t
> (maybe ssd maybe hdd) and read speed isn=B4t very well since read in =
ssd
> can be non sequencial and at hdd sequencial is prefered, the read
> balance algorithm is tuned to use the near position device, and
> sometimes ssd isn=B4t used, or less used or more used...
> a bigger speed can be done using a cache solution (ssd+hdd or ssd+rai=
d1(hdd))
> that was my test results... maybe someone have others results

You needed to use write-mostly, that would have drastically altered you=
r=20
results.  With write-mostly and write-behind enabled on the hard drives=
,=20
all reads go to the SSD instead of the hard drives, and writes complete=
=20
as soon as the SSD says it is done and the writes to the hard drives=20
happen in the background.

>
> 2011/7/19 Mike Power<mpower@dodtsair.com>:
>> Is it possible to implement a RAID 1 array using two equal size HDD =
and one
>> smaller and faster SSD.  The idea being that the resulting RAID woul=
d have
>> the same size of the HDD while picking up the speed benefits of the =
SSD.
>>   You can do something similar today by just buying two hybrid drive=
s and
>> putting them in an array.  By purchasing a dedicated SSD drive for t=
hat
>> purpose you gain the ability of controlling the size of the SSD port=
ion.  I
>> was hoping the RAID array could use the SSD more as a cache then a r=
edundant
>> storage.
>>
>> Mike Power
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
