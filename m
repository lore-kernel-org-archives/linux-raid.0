From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: RFC - device names and mdadm with some reference to udev.
Date: Mon, 3 Nov 2008 08:20:20 -0700
Message-ID: <e9c3a7c20811030720t55bf0f3i4c59fb90bf53130c@mail.gmail.com>
References: <18692.62860.863118.727187@notabene.brown>
	 <1225387127.26510.155.camel@firewall.xsintricity.com>
	 <18698.54207.663716.200113@notabene.brown>
	 <1225722871.26510.326.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1225722871.26510.326.camel@firewall.xsintricity.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, "martin f. krafft" <madduck@debian.org>, Michal Marek <mmarek@novell.com>, Kay Sievers <kay.sievers@vrfy.org>
List-Id: linux-raid.ids

On Mon, Nov 3, 2008 at 7:34 AM, Doug Ledford <dledford@redhat.com> wrote:
> On Fri, 2008-10-31 at 20:45 +1100, Neil Brown wrote:
>> > The scariest suggestion, but probably the most complete and automated,
>> > would be to have mdadm do a search on any constituent devices to find
>> > out what the eventual low level driver is.  If it's a fiber channel
>> > driver, or iSCSI, then don't auto assemble.  If it's sata/e-sata, or
>> > local SAS, then it's more likely auto assemble is fine.  But, that level
>> > of mucking around in /sys for each device would probably be quite ugly.
>>
>>
>> Quite.  And I'd almost certainly get it wrong.  One day someone might
>> come up with a solution that can be automated.  For now I think I
>> stick with configuration in mdadm.conf
>
> I'll keep this in mind as a spare time project...
>

I don't think the mucking around to determine the underlying device
would be that ugly.  Another use for this information is to set a
policy on which device ports are raid ports to enable policies like
auto-rebuild, or detect when a component member is found outside the
"raid domain".

--
Dan
