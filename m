From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: New RAID-6 snapshot
Date: Tue, 30 Dec 2003 11:22:42 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FF1D082.6040007@zytor.com>
References: <bsrns4$uaa$1@cesium.transmeta.com> <20031230172420.GS1882@matchmail.com> <3FF1C589.3070906@zytor.com> <20031230184336.GU1882@matchmail.com> <3FF1C91E.4090600@zytor.com> <20031230185835.GV1882@matchmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20031230185835.GV1882@matchmail.com>
To: Mike Fedyk <mfedyk@matchmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mike Fedyk wrote:
> 
> You mentioned that none of your snapshots have RMW in them.  Can you put up
> a patch that adds RMW to the snapshots?  Maybe someone will notice
> something...
> 

It would take considerable amounts of work to get it into releasable 
shape, because I'd have to add RMW functionality to all the implemented 
algorithms -- not just the one my machine uses.  However, if someone is 
interested in vgrepping through the source I can post the part of the 
diff patch that applies to raid6main.c.

I doubt it's actually wrong, though.  It probably just causes worse 
access patterns in my particular configuration.

> Did you get any data corruption with the RMW patch applied?
 >

No.

	-hpa

