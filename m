From: dean gaudet <dean@arctic.org>
Subject: Re: Feature Request/Suggestion - "Drive Linking"
Date: Tue, 29 Aug 2006 10:43:16 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0608291036100.30045@twinlark.arctic.org>
References: <1156868468.5611.102.camel@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1156868468.5611.102.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Bortnak <linux-raid@moro.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 30 Aug 2006, Neil Bortnak wrote:

> Hi Everybody,
> 
> I had this major recovery last week after a hardware failure monkeyed
> things up pretty badly. About half way though I had a couple of ideas
> and I thought I'd suggest/ask them.
> 
> 1) "Drive Linking": So let's say I have a 6 disk RAID5 array and I have
> reason to believe one of the drives will fail (funny noises, SMART
> warnings or it's *really* slow compared to the other drives, etc). It
> would be nice to put in a new drive, link it to the failing disk so that
> it copies all of the data to the new one and mirrors new writes as they
> happen.

http://arctic.org/~dean/proactive-raid5-disk-replacement.txt

works for any raid level actually.


> 2) This sort of brings up a subject I'm getting increasingly paranoid
> about. It seems to me that if disk 1 develops a unrecoverable error at
> block 500 and disk 4 develops one at 55,000 I'm going to get a double
> disk failure as soon as one of the bad blocks is read (or some other
> system problem ->makes it look like<- some random block is
> unrecoverable). Such an error should not bring the whole thing to a
> crashing halt. I know I can recover from that sort of error manually,
> but yuk.

Neil made some improvements in this area as of 2.6.15... when md gets a 
read error it won't knock the entire drive out immediately -- it first 
attempts to reconstruct the sectors from the other drives and write them 
back.  this covers a lot of the failure cases because the drive will 
either successfully complete the write in-place, or use its reallocation 
pool.  the kernel logs when it makes such a correction (but the log wasn't 
very informative until 2.6.18ish i think).

if you watch SMART data (either through smartd logging changes for you, or 
if you diff the output regularly) you can see this activity happen as 
well.

you can also use the check/repair sync_actions to force this to happen 
when you know a disk has a Current_Pending_Sector (i.e. pending read 
error).

-dean
