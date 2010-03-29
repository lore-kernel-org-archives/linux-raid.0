From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Auto Rebuild on hot-plug
Date: Mon, 29 Mar 2010 15:41:44 -0700
Message-ID: <e9c3a7c21003291541x229ce7e6m1666cff1ec57fa95@mail.gmail.com>
References: <20100325113543.0e2124c5@notabene.brown>
	 <905EDD02F158D948B186911EB64DB3D11C510278@irsmsx503.ger.corp.intel.com>
	 <e9c3a7c21003261737k1e753b08xc6f8eb45d0320be9@mail.gmail.com>
	 <4BB0ED13.6020507@redhat.com> <4BB0F32F.9030803@anonymous.org.uk>
	 <4BB0F820.4030707@redhat.com> <4BB12B77.8030902@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BB12B77.8030902@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Doug Ledford <dledford@redhat.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, Neil Brown <neilb@suse.de>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Bill Davidsen <davidsen@tmr.com>
List-Id: linux-raid.ids

On Mon, Mar 29, 2010 at 3:36 PM, John Robinson
<john.robinson@anonymous.org.uk> wrote:
> On 29/03/2010 19:57, Doug Ledford wrote:
>>
>> On 03/29/2010 02:36 PM, John Robinson wrote:
>
> [...]
>>>
>>> Yes, but do create the partition(s), boot sector, etc and set up th=
e
>>> spare(s).
>>
>> Really, we should never have to do this in the situation I listed: a=
ka
>> no degraded arrays exist. =A0This implies that if you had a raid1 /b=
oot
>> array, that it's still intact. =A0So partitioning and setting up boo=
t
>> loaders doesn't make sense as the new disk isn't going in to replace
>> anything. =A0You *might* want to add it to the raid1 /boot, but we d=
on't
>> know that so doing things automatically doesn't make sense.
>
> Actually I've just recently had the scenario where it would have made
> perfect sense. I hooked up the RAID chassis SATA[0-4] ports to the RA=
ID
> chassis and put 3 drives in the first 3 slots. Actually it turned out=
 I'd
> wired it up R-L not L-R so if I'd added a new drive in one of the two
> right-hand slots it would have turned up as sda on the next boot. OK,=
 to
> some extent that's me being stupid, but at the same time I correctly =
hooked
> up the first 5 SATA ports to the hot-swap chassis and would want them
> considered the same group etc.

This kind of situation is where an option-rom comes in handy i.e. the
platform firmware knows to boot from a defined raid volume.  However,
it comes with quirky constraints like not supporting > 2-drive raid1.
But I see your point that it would be nice to at least have the option
auto-grow raid1 boot arrays.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
