From: Mark Davies <mark@curly.ii.net>
Subject: Re: raid5 recovery dramas.
Date: Fri, 27 Jun 2008 19:14:51 +0800
Message-ID: <4864CBAB.90201@curly.ii.net>
References: <48608E9B.6080904@curly.ii.net> <18532.49368.984453.933541@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18532.49368.984453.933541@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> You are in a rather stick situation.

Hmm, yes, I'm starting to realise that.
> 
> Neither  sdd1 or sde1 know where they belong in the array.  If they
> did, then  "mdadm --assemble --force" would probably be able to help
> you (I should test that).  But they don't.
> 
> Do you have any boot logs from before you started the reshape that
> show which device fills which slot in the array?
> 
Not that I can find, and the physical drives have changed since I used 
dd_rescue to recover from the bad sectors.

> sdd1 has an event count of 0.  That is really odd.  Any idea how that
> happened?  Did you remove it from the array and try to add it back?
> That wouldn't have been a good idea.
> 
I don't recall removing any drives, however it was a month or so ago 
that this saga started.  I was fairly careful to not do anything 
irreversable I think.

Just checked the bash history, and I didn't remove any drives.  Amusing 
history though - you can almost smell the desperation and fear in every 
entry.

> I'm at a bit of a loss as to what to suggest.  The data is mostly
> there, but getting it back is tricky.
> 
> What you need to do is 
>    choose one of sdd and sde which you think is device  '3'
>      (sdc is 0, sdb is 1, sda is 2).
>    rewrite the metadata to assert this fact
>    assemble the array read-only with sd[abc] and the one you choose
>    read the data to make sure it is all where
>    switch to read-write so the reshape competes, leaving you with
>     a degraded array
>    add the other drive and let it recover.
> 
> The early steps in particular are not easy.

Since there's only two options, what's to stop me taking a backup of the 
metadata, and then rewriting the metadata on one drive, mounting it, 
seeing if it makes sense.  If it does, great.  If it doesn't, then 
restore the metadata and repeat the process on the other drive.

Or am I missing an important step?


> 
> I'll try to find some time to experiment, but I cannot promise
> anything.
> 
> If you can remember everything you tried to do (maybe in
> .bash_history) that might help.
> 
> NeilBrown
