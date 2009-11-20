From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: [patch 1/1] [mdadm] Add partition checks when creating a new
 array
Date: Fri, 20 Nov 2009 08:22:40 -0900 (AKST)
Message-ID: <alpine.LNX.2.01.0911200820290.10877@filesrv1.baby-dragons.com>
References: <EB332302649177439359CE520D92A0AF9F559760@irsmsx503.ger.corp.intel.com> <19196.51508.947560.851117@notabene.brown> <20091120170350.GA20882@maude.comedia.it>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091120170350.GA20882@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: Neil Brown <neilb@suse.de>, "Trela, Maciej" <Maciej.Trela@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

 	Hello Luca ,

On Fri, 20 Nov 2009, Luca Berra wrote:
> On Fri, Nov 13, 2009 at 01:49:24PM +1100, Neil Brown wrote:
>> Is there a good library that we could use?
>> libparted might be a possibility, but it seems rather over-weight.
>> /lib/libparted-1.9.so.12.0.0 is larger than /sbin/mdadm !!!
>> 
>> Are there any other libraries for reading different partition tables?
>> I guess we can open-code it if we have to but I'd be happy if another
>> solution could be found.
>
> i don't think so,
> but there are two tools
> partx from util-linux
> kpartix from multipath-tools (which is based on the former)
>
> so we could either grab code from those or just invoke
> partx -l (i believe every distro installs util-linux by default)
>
> L.
 	Fyi ,  It seems Slackware does not install util-linux ,  It uses 
util-linux-ng which does not have partx .
 	(afaik) util-linux was reported as not be being maintained .  But that 
is hearsay .
 		Hth ,  JimL
-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network&System Engineer | 3237     Holden Road |  Give me Linux  |
| babydr@baby-dragons.com | Fairbanks, AK. 99709 |   only  on  AXP |
+------------------------------------------------------------------+
