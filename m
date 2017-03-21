From: Jeff Allison <jeff.allison@allygray.2y.net>
Subject: Re: proactive disk replacement
Date: Tue, 21 Mar 2017 13:33:49 +1100
Message-ID: <CAPrpM6wtQe=h1AE-PbFr0-DyZ_wRN7gvibjfn86W0mQz77xnLg@mail.gmail.com>
References: <3FA2E00F-B107-4F3C-A9D3-A10CA5F81EC0@allygray.2y.net> <11c21a22-4bbf-7b16-5e64-8932be768c68@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <11c21a22-4bbf-7b16-5e64-8932be768c68@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I don't have a spare SATA slot I do however have a spare USB carrier,
is that fast enough to be used temporarily?

On 21 March 2017 at 01:59, Adam Goryachev
<mailinglists@websitemanagers.com.au> wrote:
>
>
> On 20/3/17 23:47, Jeff Allison wrote:
>>
>> Hi all I=E2=80=99ve had a poke around but am yet to find something defin=
itive.
>>
>> I have a raid 5 array of 4 disks amounting to approx 5.5tb. Now this dis=
ks
>> are getting a bit long in the tooth so before I get into problems I=E2=
=80=99ve
>> bought 4 new disks to replace them.
>>
>> I have a backup so if it all goes west I=E2=80=99m covered. So I=E2=80=
=99m looking for
>> suggestions.
>>
>> My current plan is just to replace the 2tb drives with the new 3tb drive=
s
>> and move on, I=E2=80=99d like to do it on line with out having to trash =
the array
>> and start again, so does anyone have a game plan for doing that.
>
> Yes, do not fail a disk and then replace it, use the newer replace method
> (it keeps redundancy in the array).
> Even better would be to add a disk, and convert to RAID6, then add a seco=
nd
> disk (using replace), and so on, then remove the last disk, grow the arra=
y
> to fill the 3TB, and then reduce the number of disks in the raid.
> This way, you end up with RAID6...
>>
>> Or is a 9tb raid 5 array the wrong thing to be doing and should I be doi=
ng
>> something else 6tb raid 10 or something I=E2=80=99m open to suggestions.
>
> I'd feel safer with RAID6, but it depends on your requirements. RAID10 is
> also a nice option, but, it depends...
>
> Regards,
> Adam
>
