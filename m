From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: [ANNOUNCE][PATCH 2.6] md: persistent (file-backed) bitmap and
 async writes
Date: Mon, 20 Sep 2004 23:28:20 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <414F9FD4.4070308@steeleye.com>
References: <40198E85.29EBC8E0@SteelEye.com>	<16422.62911.755570.855200@notabene.cse.unsw.edu.au>	<4027E342.D02202F1@SteelEye.com>	<16424.8182.876520.280031@notabene.cse.unsw.edu.au>	<402D3A86.97CF894F@SteelEye.com>	<16456.2775.641721.204171@notabene.cse.unsw.edu.au>	<4048F9AA.1BBD67F@SteelEye.com>	<406B1024.7BF88C@SteelEye.com>	<16528.49083.998593.199805@cse.unsw.edu.au>	<40C6273B.2060200@steeleye.com>	<16590.38597.170409.499394@cse.unsw.edu.au>	<40D9FA9E.9010003@steeleye.com>	<40F7E50F.2040308@steeleye.com>	<16649.61212.310271.36561@cse.unsw.edu.au>	<4119400A.40307@steeleye.com> <16668.12228.187383.596856@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16668.12228.187383.596856@cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: jejb@steeleye.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

OK, here we go again. The patch has been updated to 2.6.9-rc2 and mdadm 
1.7.0, and I've implemented the suggestions you've made below...

Patches: http://parisc-linux.org/~jejb/md_bitmap/

Thanks,
Paul

----

Neil Brown wrote:

> This is definitely heading in the right direction.  However I think
> you have missed some of the subtleties of plugging.

[snip]

> That should then have the bitmap updates happening before the
> data updates, and should cluster bitmap updates better.

OK, I've fixed that.

> The next step would be to stop write_page from being synchronous - I'm
> not comfortable about ->unplug-fn having to wait for disk io.

Well, it still does have to wait for the bitmap writes to complete 
before letting the regular writes go, but I see your point about the 
writes being submitted simultaneously (nearly) rather than being 
completely serialized.

> This looks to be quite awkward as there is not call-back that happens
> when writeback on a page is completed.  You need to have a kernel
> thread to wait for the pages to complete.  I would get the
> bitmap_daemon to do this.

OK, this is what I've done...there didn't seem to be a better place to 
do it.

> Does that make sense?

Certainly does, and seems to work...
