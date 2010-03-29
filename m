From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Auto Rebuild on hot-plug
Date: Mon, 29 Mar 2010 23:36:39 +0100
Message-ID: <4BB12B77.8030902@anonymous.org.uk>
References: <20100325113543.0e2124c5@notabene.brown>	 <905EDD02F158D948B186911EB64DB3D11C510278@irsmsx503.ger.corp.intel.com> <e9c3a7c21003261737k1e753b08xc6f8eb45d0320be9@mail.gmail.com> <4BB0ED13.6020507@redhat.com> <4BB0F32F.9030803@anonymous.org.uk> <4BB0F820.4030707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BB0F820.4030707@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, Neil Brown <neilb@suse.de>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Bill Davidsen <davidsen@tmr.com>
List-Id: linux-raid.ids

On 29/03/2010 19:57, Doug Ledford wrote:
> On 03/29/2010 02:36 PM, John Robinson wrote:
[...]
>> Yes, but do create the partition(s), boot sector, etc and set up the
>> spare(s).
> 
> Really, we should never have to do this in the situation I listed: aka
> no degraded arrays exist.  This implies that if you had a raid1 /boot
> array, that it's still intact.  So partitioning and setting up boot
> loaders doesn't make sense as the new disk isn't going in to replace
> anything.  You *might* want to add it to the raid1 /boot, but we don't
> know that so doing things automatically doesn't make sense.

Actually I've just recently had the scenario where it would have made 
perfect sense. I hooked up the RAID chassis SATA[0-4] ports to the RAID 
chassis and put 3 drives in the first 3 slots. Actually it turned out 
I'd wired it up R-L not L-R so if I'd added a new drive in one of the 
two right-hand slots it would have turned up as sda on the next boot. 
OK, to some extent that's me being stupid, but at the same time I 
correctly hooked up the first 5 SATA ports to the hot-swap chassis and 
would want them considered the same group etc.

Cheers,

John.

