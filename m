From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Further clarification of the sync_action check behavior.
Date: Mon, 25 Feb 2008 17:05:06 +1300
Message-ID: <47C23E72.8060602@sauce.co.nz>
References: <1AA1CDAD1BE022458D32739BDBB2F1AE0492633C@COMEXCHANGE.hscnet.hsc.usf.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1AA1CDAD1BE022458D32739BDBB2F1AE0492633C@COMEXCHANGE.hscnet.hsc.usf.edu>
Sender: linux-raid-owner@vger.kernel.org
To: "Harrell, Thomas" <tharrell@health.usf.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Harrell, Thomas wrote:

> Lastly, under which mounted conditions are 'check' and 'repair'
> safe/useful? Can I run both on a read-write mounted partition? Should
> they be read-only, or totally unmounted? I'm assuming since resyncs can
> occur while the overlying fs is mounted read-write, that it is both safe
> and useful to both 'check' and 'repair' while the fs is mounted
> read-write as well, but I don't see this mentioned explicitly anywhere.

Yes, running repair on a mounted R/W partition is fine, indeed should be 
done regularly, in order to "scrub" the entire array and help reduce the 
chance of a second drive failing on a bad sector, while rebuilding an 
array where a drive has already failed.

Regards,

Richard
