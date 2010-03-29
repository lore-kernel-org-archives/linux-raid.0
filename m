From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Auto Rebuild on hot-plug
Date: Mon, 29 Mar 2010 23:46:55 +0100
Message-ID: <4BB12DDF.4090303@anonymous.org.uk>
References: <20100325113543.0e2124c5@notabene.brown>	 <905EDD02F158D948B186911EB64DB3D11C510278@irsmsx503.ger.corp.intel.com>	 <e9c3a7c21003261737k1e753b08xc6f8eb45d0320be9@mail.gmail.com>	 <4BB0ED13.6020507@redhat.com> <4BB0F32F.9030803@anonymous.org.uk>	 <4BB0F820.4030707@redhat.com> <4BB12B77.8030902@anonymous.org.uk> <e9c3a7c21003291541x229ce7e6m1666cff1ec57fa95@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c21003291541x229ce7e6m1666cff1ec57fa95@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Doug Ledford <dledford@redhat.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, Neil Brown <neilb@suse.de>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Bill Davidsen <davidsen@tmr.com>
List-Id: linux-raid.ids

On 29/03/2010 23:41, Dan Williams wrote:
> On Mon, Mar 29, 2010 at 3:36 PM, John Robinson
> <john.robinson@anonymous.org.uk> wrote:
[...]
>> OK, to
>> some extent that's me being stupid, but at the same time I correctly hooked
>> up the first 5 SATA ports to the hot-swap chassis and would want them
>> considered the same group etc.
> 
> This kind of situation is where an option-rom comes in handy i.e. the
> platform firmware knows to boot from a defined raid volume.  However,
> it comes with quirky constraints like not supporting > 2-drive raid1.
> But I see your point that it would be nice to at least have the option
> auto-grow raid1 boot arrays.

As it happens this was on an Intel-chipset board with ICH10-R and option 
ROM, and I would have used IMSM if RHEL/CentOS had supported it at the 
time, so I'm following IMSM support developments closely.

Cheers,

John.
