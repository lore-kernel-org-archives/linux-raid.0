From: Greg Stark <gsstark@mit.edu>
Subject: Re: [PERFORM] Postgres on RAID5
Date: 14 Mar 2005 15:17:11 -0500
Message-ID: <87zmx6rni0.fsf@stark.xeocode.com>
References: <4231F5F2.6000509@m-cam.com> <87hdje7sjm.fsf@stark.xeocode.com>
	<33c6269f050314115339b6861d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <33c6269f050314115339b6861d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex Turner <armtuk@gmail.com>
Cc: Greg Stark <gsstark@mit.edu>, Arshavir Grigorian <ag@m-cam.com>, linux-raid@vger.kernel.org, pgsql-performance@postgresql.org
List-Id: linux-raid.ids


Alex Turner <armtuk@gmail.com> writes:

> a 14 drive stripe will max out the PCI bus long before anything else,

Hopefully anyone with a 14 drive stripe is using some combination of 64 bit
PCI-X cards running at 66Mhz...

> the only reason for a stripe this size is to get a total accessible
> size up.  

Well, many drives also cuts average latency. So even if you have no need for
more bandwidth you still benefit from a lower average response time by adding
more drives.

-- 
greg

