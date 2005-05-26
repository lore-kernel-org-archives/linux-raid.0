From: Mike Hardy <mhardy@h3c.com>
Subject: Re: Is there any way to delay reconstruction
Date: Thu, 26 May 2005 09:07:16 -0700
Message-ID: <4295F434.60203@h3c.com>
References: <Pine.LNX.4.61.0505250811520.16854@desktop.agenda.si> <eaa6dfe0505250825295cb284@mail.gmail.com> <Pine.LNX.4.61.0505260848320.22131@desktop.agenda.si>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0505260848320.22131@desktop.agenda.si>
Sender: linux-raid-owner@vger.kernel.org
To: danci@agenda.si, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



danci@agenda.si wrote:

> Rebooting the 'clean' way (CTRL-ALT-DEL or 'shutdown -r now') is no 
> problem - it doesn't require reconstruction.
> 
> It's 'cold' (or hardware) resets (such as power outages, silly users, 
> etc.) that cause that - I don't think there is much you can do about that. 

If/when you upgrade to 2.6.x you'll notice that even on the vast
majority of abnormal reboots, it still won't reconstruct. The code in
2.6.x marks the array as "clean" very quickly after writes stop so
unless the array is actually being written when it goes down, its
probably okay. On a huge array, that's nearly worth the upgrade right
there...

-Mike
