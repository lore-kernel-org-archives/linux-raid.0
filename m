From: "John Stoffel" <john@stoffel.org>
Subject: Re: RAID types & chunks sizes for new NAS drives
Date: Tue, 23 Jun 2020 14:55:04 -0400
Message-ID: <24306.20488.394049.265699@quad.stoffel.home>
References: <rco1i8$1l34$1@ciao.gmane.io>
        <24305.24232.459249.386799@quad.stoffel.home>
        <290bc100-6fb4-84bc-83ac-eed1be3d8cb6@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <290bc100-6fb4-84bc-83ac-eed1be3d8cb6@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: antlists <antlists@youngman.org.uk>
Cc: John Stoffel <john@stoffel.org>, Ian Pilcher <arequipeno@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "antlists" == antlists  <antlists@youngman.org.uk> writes:

antlists> On 23/06/2020 02:45, John Stoffel wrote:
>> In any case, make sure you get NAS rated disks, either the newest WD
>> RED+ (or is it Blue?)  In any case, make sure to NOT get the SMR
>> (Shingled Magnetic Recording) format drives.  See previous threads in
>> this group, as well as the arstechnica.com discussion about it all
>> that they disk last month.  Very informative.

antlists> I'd just avoid WD completely. They advertise REDs as
antlists> raid-capable, and they are (mostly) SMR and unfit for
antlists> purpose. BLUEs are supposedly the "desktop performance"
antlists> drives, so sticking them in a raid is not advised
antlists> anyway. But you've only got to start hammering your BLUE
antlists> performance drive, and performance would be abysmal. If you
antlists> are going for WD then RED PRO is what you need.

Don't throw out all WD drives, just because they screwed up on their
low end NAS drives.  And I do recommend that people buy drives with
the longest warranty possible, so you get a drive that the
manufacturer expects to support for quite a while.  

antlists> At least Seagate don't advertise unsuitable drives - DON'T
antlists> touch Barracudas! They say Ironwolf or Ironwolf Pro for
antlists> raid, both are fine to the best of my knowledge.

Agree.  I remember when Barracudas were the best Seagate drives... no
sticktion there.

antlists> And nobody seems to buy Toshiba but - I think it's the N300
antlists> - they do a raid range as well.

I have Toshiba drives.  Another good thing to do is to buy competing
vendor drives and pair them, because you're less likely to get hit by
a bad batch of drives.  

antlists> Don't buy REDs or Barracudas or other known-problematic
antlists> drives. They will appear to work fine until there's a
antlists> problem, at which point they will bork the raid and lose
antlists> your data. A good raid drive will tell the raid it's failed
antlists> and let the raid recover. These problem drives DON'T tell
antlists> the raid what's going on, and by the time the raid finds out
antlists> it's too late.

The RED+ I think are all supposed to be CMR drives no matter what.

As Wols has said in the past, getting drives with SCTERC support is
key.  They're going to be more expensive, but how much is your data
worth?

I think Wols and I are in agreement overall, just differing in
details.  He's done a great job with the RAID wiki and helping people
when they get into trouble.  
