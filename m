From: antlists <antlists@youngman.org.uk>
Subject: Re: RAID types & chunks sizes for new NAS drives
Date: Tue, 23 Jun 2020 16:36:51 +0100
Message-ID: <290bc100-6fb4-84bc-83ac-eed1be3d8cb6@youngman.org.uk>
References: <rco1i8$1l34$1@ciao.gmane.io>
 <24305.24232.459249.386799@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <24305.24232.459249.386799@quad.stoffel.home>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>, Ian Pilcher <arequipeno@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23/06/2020 02:45, John Stoffel wrote:
> In any case, make sure you get NAS rated disks, either the newest WD
> RED+ (or is it Blue?)  In any case, make sure to NOT get the SMR
> (Shingled Magnetic Recording) format drives.  See previous threads in
> this group, as well as the arstechnica.com discussion about it all
> that they disk last month.  Very informative.

I'd just avoid WD completely. They advertise REDs as raid-capable, and 
they are (mostly) SMR and unfit for purpose. BLUEs are supposedly the 
"desktop performance" drives, so sticking them in a raid is not advised 
anyway. But you've only got to start hammering your BLUE performance 
drive, and performance would be abysmal. If you are going for WD then 
RED PRO is what you need.

At least Seagate don't advertise unsuitable drives - DON'T touch 
Barracudas! They say Ironwolf or Ironwolf Pro for raid, both are fine to 
the best of my knowledge.

And nobody seems to buy Toshiba but - I think it's the N300 - they do a 
raid range as well.

Don't buy REDs or Barracudas or other known-problematic drives. They 
will appear to work fine until there's a problem, at which point they 
will bork the raid and lose your data. A good raid drive will tell the 
raid it's failed and let the raid recover. These problem drives DON'T 
tell the raid what's going on, and by the time the raid finds out it's 
too late.

Cheers,
Wol
