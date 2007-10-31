From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: xosview + RAID (was: switching root fs '/'...)
Date: Wed, 31 Oct 2007 21:12:19 +0100
Message-ID: <20071031211219.1c0a6e6d@absurd>
References: <20071030210721.386ca2fa@absurd>
	<1193781699.10336.585.camel@firewall.xsintricity.com>
	<20071031160152.764e2a45@absurd>
	<1193852288.10336.590.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1193852288.10336.590.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Doug Ledford said:     (by the date of Wed, 31 Oct 2007 13:38:08 -0400)


> Now that grub's installed, you won't have to do anything manual again.
> The only time you might have to repeat that grub install procedure is if
> you loose a drive and need to add a new one back in, then the new one
> will need it.

great! many thanks again.

Another thing.. 

I'm using xosview to monitor my system activity
(others prefer gkremml, or sth else ;-). To see RAID I can run
xosview like this:

  xosview -xrm "xosview*RAID:true" -xrm "xosview*RAIDdevicecount:2"

but I have three devices (md0, md1, md2), so I should use
RAIDdevicecount:3 but it gives following error:

  terminate called after throwing an instance of 'std::bad_alloc'
    what():  St9bad_alloc
  Aborted

anybody else here is using xosview?

-- 
Janek Kozicki                                                         |
