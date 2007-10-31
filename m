From: David Greaves <david@dgreaves.com>
Subject: Re: xosview + RAID
Date: Wed, 31 Oct 2007 20:47:32 +0000
Message-ID: <4728E9E4.5080301@dgreaves.com>
References: <20071030210721.386ca2fa@absurd>	<1193781699.10336.585.camel@firewall.xsintricity.com>	<20071031160152.764e2a45@absurd>	<1193852288.10336.590.camel@firewall.xsintricity.com> <20071031211219.1c0a6e6d@absurd>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071031211219.1c0a6e6d@absurd>
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Janek Kozicki wrote:
> I'm using xosview to monitor my system activity
> (others prefer gkremml, or sth else ;-). To see RAID I can run
> xosview like this:
> 
>   xosview -xrm "xosview*RAID:true" -xrm "xosview*RAIDdevicecount:2"
> 
> but I have three devices (md0, md1, md2), so I should use
> RAIDdevicecount:3 but it gives following error:
> 
>   terminate called after throwing an instance of 'std::bad_alloc'
>     what():  St9bad_alloc
>   Aborted
> 
> anybody else here is using xosview?
funny you should mention that :)
I submitted a bug report in Mar 2005

It just got some attention a couple of weeks back:

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=+300924

David
