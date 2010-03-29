From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Auto Rebuild on hot-plug
Date: Mon, 29 Mar 2010 19:36:31 +0100
Message-ID: <4BB0F32F.9030803@anonymous.org.uk>
References: <20100325113543.0e2124c5@notabene.brown>	 <905EDD02F158D948B186911EB64DB3D11C510278@irsmsx503.ger.corp.intel.com> <e9c3a7c21003261737k1e753b08xc6f8eb45d0320be9@mail.gmail.com> <4BB0ED13.6020507@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BB0ED13.6020507@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, Neil Brown <neilb@suse.de>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Bill Davidsen <davidsen@tmr.com>
List-Id: linux-raid.ids

On 29/03/2010 19:10, Doug Ledford wrote:
[...]
> I'm also having a hard time justifying the existence of the metadata
> keyword.
[...]
> So, that leaves us back to not really needing the
> metadata keyword as the disks present in the path spec glob should be
> uniform in the metadata type and we should be able to simply use the
> right metadata from that.

I think I agree; in my limited scenario I might want to use 0.90 
metadata on my sdX1 to make my /boot, but 1.x on my other partitions, 
and it'll be whole discs that match my path spec so one metadata type 
wouldn't apply uniformly.

[...]
> All of the above actions are related to domains that are degraded.  But
> what to do if the array isn't degraded?  We could add the device as a
> spare, but if the array isn't degraded, adding a new hot spare doesn't
> really *do* anything.  No rebuild will start, nothing immediate happens,
> it just goes in and sits there.  And now that we have all these fancy
> grow options, it's not entirely clear that a user would want that
> anyway.  So, I would argue that if the array isn't degraded, then there
> is no sense of emergency in our actions, and there exists multiple
> options for what to do with the device, some include being a hot spare
> while others include using the device to grow the array, and the
> possibilities and answers to what to do here are not at all clear.  Even
> if the user had previously configured us to treat the device as a spare,
> they may change their mind and want to grow things.  Given that there's
> no immediate need to do anything as there aren't any degraded arrays, I
> say let the user do whatever they want and don't try to do anything
> automatically as it seems likely to me that the user's wants in this
> area are likely to change from time to time based on circumstances and
> having them update the config file prior to inserting the device is more
> klunky than just telling them to do whatever they want themselves after
> inserting the device.
[...]

Yes, but do create the partition(s), boot sector, etc and set up the 
spare(s). The user installed the system with anaconda or whatever, and 
may not know the incantations to partition his new disc or install a 
boot loader, so if he's managed to configure a mdadm.conf which says the 
spare slots in his RAID chassis should belong to mdadm, prepare them for 
him. Then all he needs to do is issue whatever grow command.

I think the exception to this is /boot on RAID-1, where I would prefer 
to be able to have the system automatically add the new partition as an 
active mirror instead of a hot spare, in case this new drive is what we 
have to boot off next time.

I suppose there might be circumstances where you want to do something 
else, like Netgear do on their ReadyNAS, but while it might be nice to 
be able to configure that sort of automatic growing and reshaping, it 
doesn't belong in the default config.

Cheers,

John.

