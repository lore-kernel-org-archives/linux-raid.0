From: Mike Fedyk <mfedyk@matchmail.com>
Subject: Re: New RAID-6 snapshot
Date: Tue, 30 Dec 2003 10:58:35 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031230185835.GV1882@matchmail.com>
References: <bsrns4$uaa$1@cesium.transmeta.com> <20031230172420.GS1882@matchmail.com> <3FF1C589.3070906@zytor.com> <20031230184336.GU1882@matchmail.com> <3FF1C91E.4090600@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3FF1C91E.4090600@zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Dec 30, 2003 at 10:51:10AM -0800, H. Peter Anvin wrote:
> Now, you'd never use RMW only; it's only used when it should be faster 
> than RCW, which is why I'm a bit surprised about the performance 
> degradation.  With only six drives in my test system it's pretty clear 
> that RMW should very rarely be invoked, however, the performance ought 
> to have stayed the same rather than slip.

You mentioned that none of your snapshots have RMW in them.  Can you put up
a patch that adds RMW to the snapshots?  Maybe someone will notice
something...

Did you get any data corruption with the RMW patch applied?
