From: Neil Brown <neilb@suse.de>
Subject: Re: MD Feature Request: non-degraded component replacement
Date: Fri, 19 Dec 2008 15:11:47 +1100
Message-ID: <18763.7939.549010.518201@notabene.brown>
References: <49477689.2010208@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Greaves on Tuesday December 16
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday December 16, david@dgreaves.com wrote:
> Hi Neil
> 
> I brought this up in October but got no response - since you seem to be on a
> roll I thought I'd try again...
> 
> Summary: Add a spare and 'mirror-fail' a device. The spare is synced with the
> to-be-removed device and any read errors are corrected from the remaining raid
> devices. Once synced, the  to-be-removed device is failed and the spare takes
> its place. At no point is the array degraded.

Yes, I've come to the conclusion that this probably is a good idea.

See my 'road-map' that I just posted.

Thanks,
NeilBrown


> 
> IMHO This one should be high on the todo list. Especially if it's a
> pre-requisite for other improvements to resilience.
> 
> Right now, if a drive fails or shows signs of going bad then you get into a very
>  risky situation.
> 
> I'm sure most here know that the risk is because removing the failing drive and
> installing a good one to re-sync puts you in a very vulnerable position; if
> another drive fails (even one bad block) then you lose data.
> 
> The solution involves raid1 - but it needs a twist of raid5/6 and it was
> discussed ages ago; see:
>   http://arctic.org/~dean/proactive-raid5-disk-replacement.txt
> 
> 
> I think this is what was discussed:
> 
> Assume md0 has drives A B C D
> D is failing
> E is new
> 
> * add E as spare
> * set E to mirror 'failing' drive D (with bitmap?)
> * subsequent writes go to both D+E
> * recover 99+% of data from D to E by simple mirroring
> * any read failures on D when reading from md0 or mirroring D->E are recovered
> from reading ABC not E unless E is in sync. D is not failed out. (and it's these
> tricks that stops users from doing all this manually)
> * any md0 sector read failure on ABC can still (hopefully) be read from D even
> if not yet mirrored to E (also not possible if done manually)
> * once E is mirrored, D is removed and  the job is done
> 
> Personally I think this feature is more important than the reshaping requests;
> of course that's just one opinion after replacing about 20 flaky 1Tb drives in
> the past 6 months :)
> 
> David
> 
> -- 
> "Don't worry, you'll be fine; I saw it work in a cartoon once..."
