From: Sean Caron <scaron@umich.edu>
Subject: Re: Automatically start two-level mdadm RAID arrays (i.e. RAID 60) on boot?
Date: Fri, 16 Feb 2018 11:39:56 -0500
Message-ID: <CAA43vkUy=ewgMnajwoghHMuSbVzgMJVoSXF-kTACqCGMH4TMUA@mail.gmail.com>
References: <CAA43vkUG8LrMUjazeYFtGVKVuTvrYRPe-UcPb21r=xeYpctpmg@mail.gmail.com>
 <20180216020217.2a9c7690@natsu> <4ebbb6bf-70a9-fb85-1b9f-82850a187e47@turmel.org>
 <39e0bf6b-4280-590c-9d96-013c70d4e0a4@fnarfbargle.com> <CAA43vkW82nJXmwo7=HAhO+shx_Obak_tm7Vy0EKWW+HWW6brnw@mail.gmail.com>
 <20180216110004.7DBF9240159@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20180216110004.7DBF9240159@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>, Sean Caron <scaron@umich.edu>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, Phil Turmel <philip@turmel.org>, Roman Mamedov <rm@romanrm.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Feb 16, 2018 at 6:00 AM, Wolfgang Denk <wd@denx.de> wrote:
> Dear Sean,
>
> In message <CAA43vkW82nJXmwo7=HAhO+shx_Obak_tm7Vy0EKWW+HWW6brnw@mail.gmail.com> you wrote:
>>
>> As it is now, we just populate /etc/mdadm/mdadm.conf ARRAY lines with
>> the output of mdadm --examine --scan after building all the RAID 6
>> strings and the top level RAID 0 container. This gives the result
>> where the RAID 0 containers are the last lines in the file, after all
>> the RAID 6 strings. For example, on a machine with RAID 6 strings
>> md0...4 and RAID 0 string md5 (containing md0...md4), we have
>> mdadm.conf contents like:
>
> Just in case it is not clear (you didn't mention you did): after
> generating /etc/mdadm/mdadm.conf you _must_ also rebuild the
> initramfs image for your running kernel, so the new mdadm.conf gets
> included there, where it is actually needed.
>
> Best regards,
>
> Wolfgang Denk
>

We always run update-initramfs -c -v -k "<kernelver>" after generating
the mdadm.conf file as part of our build procedure. The Ubuntu package
manager also kicks off a triggered update-initramfs every time a new
version of linux-image-generic is installed, so it's included on
subsequent kernel updates. I feel like none of the arrays would start
if mdadm.conf were not included in the initrd?

Best,

Sean
