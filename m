From: Tim Small <tim@buttersideup.com>
Subject: what is the best multi-SATA-controller-on-a-single-board out there?
Date: Mon, 02 Aug 2004 11:22:35 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <410E15EB.7030407@buttersideup.com>
References: <20040730234706.M12321@contactbda.com>	 <Pine.LNX.4.44.0407311045460.4528-100000@uplift.swm.pp.se>	 <20040801150258.M30882@contactbda.com> <1091382829.11770.14.camel@tinny.home.foo>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1091382829.11770.14.camel@tinny.home.foo>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Scott T. Smith wrote:

>Along these lines... what is the best
>multi-SATA-controller-on-a-single-board out there?  I've had issues with
>the 3Ware controllers in JBOD mode where one disk failing affects the
>rest of the drives on the controller; are there better (i.e. more
>independent) ones out there?
>  
>
I've used multiple cheap Promise TX4s PCI cards, and Silicon Image 
onboard controllers (e.g Tyan Thunder K8SPro dual Opteron board).  
Haven't had at SATA drives fail yet, so I can't say anything about 
reliability with failed drives.

The Promise cards, are cheap, but only do 66Mhz/32 bit PCI and provide 
four SATA ports, so they may not be well suited to some boards..  Both 
chipsets were used with libata on 2.6 kernels, with a mixture of s/w 
raid5, and s/w raid1.  The only slight irritation is the current lack of 
smartd support (pending libata driver support).

I haven't done much in the way of benchmarking on these machines, (just 
tested linear reads at 42MB/s on 2x 250G/7200 rpm Raid1, and 62MB/s on a 
5x 250G/7200 rpm Raid5), but performance is good enough for the tasks 
that they will be carrying out.  Two of these boxes are not commissioned 
yet, so if anyone would like to have me run some benchmarks, let me know 
what to run, and I'll see what I can do.

BTW, I have just run a linear read test on a similar machine (same 
kernel), but with 2x PATA (similar 250G drives), and get 57MB/s on 
Raid1, so maybe libata performance isn't quite there yet.

Tim.

