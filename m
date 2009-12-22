From: Brett Russ <bruss@netezza.com>
Subject: Re: bug/race in md causing device to wedge in busy state
Date: Tue, 22 Dec 2009 16:48:53 -0500
Message-ID: <hgres6$20r$1@ger.gmane.org>
References: <4B2983AE.8020002@netezza.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B2983AE.8020002@netezza.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/16/2009 08:04 PM, Brett Russ wrote:
> I'm seeing cases where an attempted remove of a manually faulted disk
> from an existing RAID unit can fail with mdadm reporting "Device or
> resource busy". I've reduced the problem down to the smallest set that
> reliably reproduces the issue:
>
> Starting with 2 drives (a,b), each with at least 3 partitions:
> 1) create 3 raid1 md's on the drives using the 3 partitions
> 2) fault & remove drive b from each of the 3 md's
> 3) zero the superblock on b so it forgets where it came from (or use a
> third drive c...) and add drive b back to each of the 3 md's
> 4) fault & remove drive b from each of the 3 md's
>
> The problem was originally seen sporadically during the remove part of
> step 2, but is *very* reproducible in the remove part of step 4. I
> attribute this to the fact that there's guaranteed I/O happening during
> this step.
>
> Now here's the catch. If I change step 4 to:
> 4a) fault drive b from each of the 3 md's
> 4b) remove drive b from each of the 3 md's
> then the removes haven't yet been seen to fail with BUSY yet (i.e. no
> issues).
>
> But my scripts currently do this instead for each md:
> 4a) fault drive b from md
> 4b) sleep 0-10 seconds
> 4c) remove drive b md
> which will fail on the remove from one of the md's, almost guaranteed.
> It seems odd to me that no amount of sleeping in between these steps can
> allow me to reliably remove a faulted member of an array.

Neil et al,

Would you expect to see a dependency across md devices on the same 
spindle which would affect a device remove like this?

I have to assume it's a bug since the condition doesn't clear up even 
after removing the rest of the devices on the spindle, i.e. the 
partition permanently reports busy.

-Brett

