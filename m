From: Daniel Pittman <daniel@rimspace.net>
Subject: Re: mdadm --dangerous-no-resync equivalent
Date: Thu, 10 Mar 2005 13:54:25 +1100
Message-ID: <87r7iomcri.fsf@enki.rimspace.net>
References: <1110416418.4371.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10 Mar 2005, flame@ivt.com.au wrote:
> Hi,
>
> I have an installer (http://sourceforge.net/projects/terraformix/) that
> creates Raid 1 arrays, previously the arrays were created with mkraid
> using the --dangerous-no-resync option. I am now required to build the
> arrays with mdadm and have the following questions ;
>
> 1) Is there an equivalent of --dangerous-no-resync in mdadm ?
>
> 2) Can I just go ahead and install onto a newly created RAID 1 array
> without waiting for it to resync ?

Yes.

> 3) Can I just go ahead and install onto a newly created RAID 5 array
> without waiting for it to resync ?

Yes.

Also, you can happily reboot while the resync is no progress with the
full expectation that it will work correctly -- assemble, then take up
the resync process again -- when your machine restarts.

I have had no problems with this at all, despite doing a large number of
installs onto both of those RAID levels.

Also, the Debian installer for testing/unstable makes the assumption
that this will "just work" in the RAID component -- at least, in so far
as not taking any special care to avoid rebooting during the resync
process.

Regards,
        Daniel
-- 
A large number of installed systems work by fiat.
That is, they work by being declared to work.
        -- Anatol Holt

