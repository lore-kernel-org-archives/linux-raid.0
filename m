From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: New RAID-6 snapshot
Date: Tue, 30 Dec 2003 10:51:10 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FF1C91E.4090600@zytor.com>
References: <bsrns4$uaa$1@cesium.transmeta.com> <20031230172420.GS1882@matchmail.com> <3FF1C589.3070906@zytor.com> <20031230184336.GU1882@matchmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20031230184336.GU1882@matchmail.com>
To: Mike Fedyk <mfedyk@matchmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mike Fedyk wrote:
> 
> Does that mean that RRW (as the name seems to imply) would need to read the
> entire stripe before it could write back the updated stripe compared to a
> partial read with RMW? 
 >

Sort of.  If you have, say, seven drives total: D D D D D P Q, the 
access pattern look like:

D D D D D P Q
     ^
     Write this drive

... then RCW needs to read:

D D - D D - -

... and RMW needs to read:

- - D - - P Q


Now, if this is a "small" write (smaller than a page) then the stripe 
being modified always needs to be written, which helps RMW.  On the 
other hands, large writes really help RCW:

D D D D D P Q
^^^^^^^
Write these four drives

... then RCW only needs to read one drive, whereas RMW needs to read six.

Now, you'd never use RMW only; it's only used when it should be faster 
than RCW, which is why I'm a bit surprised about the performance 
degradation.  With only six drives in my test system it's pretty clear 
that RMW should very rarely be invoked, however, the performance ought 
to have stayed the same rather than slip.

	-hpa

