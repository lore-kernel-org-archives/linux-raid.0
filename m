From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: dmraid - where is the raid done?
Date: Mon, 27 Oct 2008 17:32:13 -0700
Message-ID: <e9c3a7c20810271732v30c08b6by6a8c1eb015261ba2@mail.gmail.com>
References: <1225120062.20830.34.camel@pc.ilinx>
	 <slrnggck8i.ond.Mario.Holbe@darkside.dyn.samba-tng.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <slrnggck8i.ond.Mario.Holbe@darkside.dyn.samba-tng.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Mario 'BitKoenig' Holbe <Mario.Holbe@tu-ilmenau.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Oct 27, 2008 at 4:38 PM, Mario 'BitKoenig' Holbe
<Mario.Holbe@tu-ilmenau.de> wrote:
>> The message there seems to be, if you are going to do it in software
>> anyway, why not just skip the IO card RAID and just use MD?
>
> Yes, that's the much cleaner approach. And, for Linux, the more stable
> one as well - since dmraid doesn't manage drive-faults etc. anyways as
> noted above.
>

...or with the upcoming mdadm-3.0[1] you will be able to have the
stability of MD and the boot support for bios raid.  At least for
Intel platforms.

--
Dan

[1] http://marc.info/?l=linux-raid&m=122221593720893&w=2
