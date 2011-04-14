From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Any pros or cons of using full disk versus partitons?
Date: Thu, 14 Apr 2011 12:23:52 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1104141221270.14027@uplift.swm.pp.se>
References: <07a801cbfa12$64b8a950$2e29fbf0$@gmail.com> <20110413.132112.102552472.davem@davemloft.net> <io52j7$cg4$1@dough.gmane.org> <BANLkTi=vgVxVRomvpkX5uxSvN9Fe1cgvoQ@mail.gmail.com> <20110414181159.48a2086e@notabene.brown>
 <20110414143007.477e6dcd@natsu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110414143007.477e6dcd@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: NeilBrown <neilb@suse.de>, CoolCold <coolthecold@gmail.com>, David Brown <david.brown@hesbynett.no>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 14 Apr 2011, Roman Mamedov wrote:

> But then the 1.x+ metadata is still stored at the very end of the 
> device, which makes it vulnerable to the HPA problem described above.

That's why I prefer v1.2 superblocks, it's stored safely away from MBR 
overwrites, but still not at the end.

Quoting "man mdadm"

1, 1.0, 1.1, 1.2
Use the new version-1 format superblock.  This has few 
restrictions.  The different sub-versions store the superblock at 
different locations on the device, either at the end (for 1.0), at the 
start (for 1.1) or 4K from the start (for 1.2).

I consider v1.0 and v1.1 as dangerous because of why you wrote, as well as 
accidental MBR writes.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
