From: "David Rees" <drees76@gmail.com>
Subject: Re: Software RAID1 deadlock in 2.6.25 kernels
Date: Tue, 1 Jul 2008 12:00:28 -0700
Message-ID: <72dbd3150807011200i2628f972r98170da5a1dfbf5d@mail.gmail.com>
References: <48650567.3000501@w1nr.net>
	 <18533.20961.694041.556763@notabene.brown>
	 <20080630092348.GJ17557@boogie.lpds.sztaki.hu>
	 <4868C410.2060005@w1nr.net>
	 <20080630115926.GA31564@ruf099.fkie.fgan.de>
	 <4868E050.7090904@tmr.com> <4868E45F.30105@w1nr.net>
	 <4869404A.2000500@sauce.co.nz> <48693FBC.4090709@kmaclub.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48693FBC.4090709@kmaclub.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "michael@kmaclub.com" <michael@kmaclub.com>
Cc: Richard Scobie <richard@sauce.co.nz>, Mike McCarthy <mike@w1nr.net>, Bill Davidsen <davidsen@tmr.com>, Michael Bussmann <bus@mb-net.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jun 30, 2008 at 1:19 PM, michael@kmaclub.com
<michael@kmaclub.com> wrote:
> Richard Scobie wrote:
>> Mike McCarthy wrote:
>>> Bill Davidsen wrote:
>>>> Wonder if hardware or software is happening, sounds like an mishandled
>>>> hardware error, but I'm guessing. I have a server with RAID1 and Fedora
>>>> 2.6.22.14-72.fc6PAE kernel, up 72 days, no problems.
>>>
>>> 2.6.22 is running fine.  The problems are in the 2.6.25 kernel (FC9 and
>>> SUSE 11.0)
>>
>> FC9 running on RAID 1 (ata_piix) for the last 3 weeks or so, with no
>> trouble.
>
> Same here.  I haven't had any issues with RAID 1 on Fedora 9.
>
> So the issue isn't biting everyone but there is always the chance something
> is wrong with a specific controller or configuration.

FWIW, me too. I have three different Fedora 9 systems running the
latest Fedora kernels based on 2.6.25 which are running software RAID
1 without any issues at all.

-Dave
