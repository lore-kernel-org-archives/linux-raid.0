From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers [xfs]
Date: Sat, 13 Dec 2008 11:40:11 -0600
Message-ID: <4943F37B.8080405@sandeen.net>
References: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan>	<493A9BE7.3090001@sandeen.net>	<alpine.DEB.1.10.0812130724340.18746@p34.internal.lan>	(sfid-20081213_171213_704814_AA9856DD) <200812131826.25280.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200812131826.25280.Martin@lichtvoll.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-xfs@oss.sgi.com, linux-raid@vger.kernel.org, Alan Piszcz <ap@solarrain.com>xfs@oss.sgi.com
List-Id: linux-raid.ids

Martin Steigerwald wrote:

> At the moment it appears to me that disabling write cache may often give 
> more performance than using barriers. And this doesn't match my 
> expectation of write barriers as a feature that enhances performance. 

Why do you have that expectation?  I've never seen barriers advertised
as enhancing performance.  :)

I do wonder why barriers on, write cache off is so slow; I'd have
thought the barriers were a no-op.  Maybe I'm missing something.

> Right now a "nowcache" option and having this as default appears to make 
> more sense than defaulting to barriers. 

I don't think that turning off write cache is something the filesystem
can do; you have to take that as an administrative step on your block
devices.

> But I think this needs more 
> testing than just those simple high meta data load tests. Anyway I am 
> happy cause I have a way to speed up XFS ;-).

My only hand-wavy concern is whether this has any adverse physical
effect on the drive (no cache == lots more head movement etc?) but then
barriers are constantly flushing/invalidating that cache, so it's
probably a wash.  And really, I have no idea.  :)

-Eric

