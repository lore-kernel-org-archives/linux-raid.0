From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Linux MD? Or an H710p?
Date: Sun, 20 Oct 2013 10:50:08 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1310201048350.26825@uplift.swm.pp.se>
References: <526328AE.2020908@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <526328AE.2020908@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Bergman <sbergman27@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 19 Oct 2013, Steve Bergman wrote:

> Any general guidance would be appreciated. We'll probably be keeping 
> this server for 7 years, and it's pretty important to us. So I'm really 
> wanting to get this right.

I prefer to use hardware raid for the boot device, because it can be a 
mess to make sure grub can boot off of any of the two boot drives and to 
re-assure this is true over time.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
