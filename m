From: Lucas Barbuto <lucas@qk.com.au>
Subject: Re: Problems mounting root file system with software RAID-1
Date: Wed, 29 Jan 2003 10:01:03 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030128230103.GB26920@qk.com.au>
References: <6F5F11DC834C7F47958471A2B71DEB9F2E9894@wbke2k.wbk.uni-karlsruhe.de>
Reply-To: Lucas Barbuto <lucas@qk.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6F5F11DC834C7F47958471A2B71DEB9F2E9894@wbke2k.wbk.uni-karlsruhe.de>
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Ulf,

Thanks for your reply.

On Tue, Jan 28, 2003 at 08:15:31AM +0100, Dambacher, Ulf wrote:
> first, is the promise driver compiled in?
> - not in /proc/modules?
> - gives message at boot time about partititions and drives?

Yes, that's correct.

> second, do you use raid autostart on md1? 
> - partitition id is set to hex(fd)?
> - autostart support compiled in?
> - kernel searches for autostart devices at boot time?
> - kernel finds any autostart devices?

Hmm, I'm not sure what this 'autostart' is.  All the partition types are
set to 0xfd.

> if all this is ok, please send the complete bootup messages (dmesg) for more
> information

How do you save the boot messages for a system that has crashed?

Regards,

Lucas
