From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Mon, 23 Jan 2006 21:02:16 -0500
Message-ID: <43D58AA8.2090903@cfl.rr.com>
References: <17360.5011.975665.371008@cse.unsw.edu.au> <43D02033.4070008@cfl.rr.com> <17360.9233.215291.380922@cse.unsw.edu.au> <20060120183621.GA2799@redhat.com> <20060120225724.GW22163@marowsky-bree.de> <20060121000142.GR2801@redhat.com> <20060121000344.GY22163@marowsky-bree.de> <20060121000806.GT2801@redhat.com> <20060121001311.GA22163@marowsky-bree.de> <20060123094418.GX2801@redhat.com> <20060123125420.GE1686@vianova.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060123125420.GE1686@vianova.fi>
Sender: linux-raid-owner@vger.kernel.org
To: vherva@vianova.fi
Cc: Heinz Mauelshagen <mauelshagen@redhat.com>, Lars Marowsky-Bree <lmb@suse.de>, Neil Brown <neilb@suse.de>, Jan Engelhardt <jengelh@linux01.gwdg.de>, "Lincoln Dale (ltd)" <ltd@cisco.com>, Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Steinar H. Gunderson" <sgunderson@bigfoot.com>
List-Id: linux-raid.ids

Ville Herva wrote:
> PS: Speaking of debugging failing initrd init scripts; it would be nice if
> the kernel gave an error message on wrong initrd format rather than silently
> failing... Yes, I forgot to make the cpio with the "-H newc" option :-/.
>   

LOL, yea, that one got me too when I was first getting back into linux a 
few months ago and had to customize my initramfs to include dmraid to 
recognize my hardware fakeraid raid0.  Then I discovered the mkinitramfs 
utility which makes things much nicer ;)


