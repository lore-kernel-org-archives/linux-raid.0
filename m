From: Tim Small <tim@buttersideup.com>
Subject: Re: what is the best multi-SATA-controller-on-a-single-board out
 there?
Date: Tue, 03 Aug 2004 09:55:09 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <410F52ED.9070403@buttersideup.com>
References: <20040730234706.M12321@contactbda.com>  <Pine.LNX.4.44.0407311045460.4528-100000@uplift.swm.pp.se>  <20040801150258.M30882@contactbda.com> <1091382829.11770.14.camel@tinny.home.foo> <410E15EB.7030407@buttersideup.com> <Pine.LNX.4.58.0408021700230.7852@web1.mmaero.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0408021700230.7852@web1.mmaero.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jon Lewis wrote:

>On Mon, 2 Aug 2004, Tim Small wrote:
>  
>
>>The Promise cards, are cheap, but only do 66Mhz/32 bit PCI and provide
>>four SATA ports, so they may not be well suited to some boards..  Both
>>chipsets were used with libata on 2.6 kernels, with a mixture of s/w
>>raid5, and s/w raid1.  The only slight irritation is the current lack of
>>smartd support (pending libata driver support).
>>    
>>
>
>With what distros / exactly which kernels?  I've been testing a system
>  
>
I'm using kernel.org 2.6.8rc2 (also used 2.6.5rc3), with libata on 
Debian/Sarge (not that the distribution should matter, this is all 
kernel side stuff) - both on Xeons, and Opterons, all filesystems are 
ext3.  I was expecting to have some hassle with these systems, but have 
had none up to now (in service a few months).  The revised (minor) 
shortcoming list is:

. Sustained throughput not as high as the PATA based arrays (yet)
. No hot-plug support (yet)
. No smartd support (yet)

Tim.

