From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: RE: 3ware 7500-12, bad write speed
Date: Thu, 26 Sep 2002 07:25:45 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0209260706470.23239-100000@uplift.swm.pp.se>
References: <A1964EDB64C8094DA12D2271C04B812672C6FC@tabby>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A1964EDB64C8094DA12D2271C04B812672C6FC@tabby>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 25 Sep 2002, Adam Radford wrote:

> This is because of the vmlayer and your bdflush settings and the fact
> that you are running a journalling filesystem.  Our raid 5 caching
> strategy gives the best results when given sequential writes.  Doing
> journaling fs and caching writes in the vmlayer causes the firmware
> caching strategy to perform 'sub optimal' since the lba's accessed
> aren't actually sequential.  Thus your 15 MB/s.  We do do elevator seek
> in the FW, but this can only help you so much.

Any specifics in the bdflush settings I should be aiming for? I have 
fiddeled some with the settings and I cannot seem to make much of a 
difference.

Would it help to mount that particular partition in with "sync" mount
option? I have already changed the mount option to data=writeback in order
to have less journaling data being thrown around.

What I also do not understand is that in some 5 second intervals I get 
iostat claiming there was only 500 kilobyte/s written when doing my test 
with dd if=/dev/zero of=testfile bs=1024000 count=2000. What in the world 
could cause the vm layer to have that big of an impact that it would only 
be able to write just 500 kilobytes in a second?

I have this bdflush setting at the moment:

echo 100 5000 640 2560 150 30000 5000 1884 2 > /proc/sys/vm/bdflush

I have made several radical changes to the bdflush settings and if any, it
made things worse.
 
-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

