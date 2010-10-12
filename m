From: Neil Brown <neilb@suse.de>
Subject: Re: reboot before reshape from raid 5 to raid 6 (was in state
 resync=DELAYED). Doesn't assemble anymore.
Date: Wed, 13 Oct 2010 07:46:12 +1100
Message-ID: <20101013074612.6abbb698@notabene>
References: <20101012142752.GA16007@leontine.pompomgali.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101012142752.GA16007@leontine.pompomgali.com>
Sender: linux-raid-owner@vger.kernel.org
To: Simon S <simon@sehier.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 12 Oct 2010 16:27:53 +0200
Simon S <simon@sehier.fr> wrote:

> Hi all,
> 
> I had a config with 5 disks and 3 raid 5 arrays:
> 
> md2 : system root
> md3 : swap
> md4 : data
> 
> I added a 6th disk with the intention of growing my raid5 into raid6.
> 
> The step I used were :
> 
> # mdadm /dev/mdX -a  /dev/newdiskX
> # mdadm -G --level 6 -n 6 /dev/mdX --backup-file /mdXbackup
>  (yes, with backup file on root partition md2...)

Bad idea..  Very bad idea.

> 
> The md3 array reshaped without any problem.
> md2 seemed to reshape well until it reaches 50.4%, then the rebuild speed stalled at 14Kb/s.

This is the expected consequence of that bad idea.  Unfortunately it would be
hard to reliably get mdadm to complain about that, though I guess the common
cases are easy to protect against ... added to 'todo' list

> md4 was still in the state "resync=DELAYED" then.
> 
> As the rebuild process seemed hung, I restart the machine ... bad idea.

Not really, nothing else would have worked.

> 
> Now mdadm refuses to assemble md2 and md4, and displays this message :
> 
>   mdadm: Failed to restore critical section for reshape, sorry.
>     Possibly you needed to specify the --backup-file
> 
> md2 is my linux installation, not very bad if I lose this one.
> 
> md4 however contains valuable data.
> 
> While md4 was still in the state resync=DELAYED before the shutdown, I expect
> it should not has been (to much) modified and can be recovered.

Very true.

> 
> Any idea on how I could safely do it ?
> 
> Should I give a try to the hack "Get 'Grow_restart' to always return 0."
> mentionned by Neil Brown on 22 april 2010 in this mailing list ?

That is your best bet.  I plan to make that easier to do in mdadm-3.2 (no
recompile necessary).

Before you do, check "mdadm -E /dev/newdiskX" and make sure the "Reshape
position" is 0.  If it is you should be fine.  I

It won't be for md2 of course.  So md will quite possible have some
corruption.  Run fsck on it an it will probably be mostly OK, but there is a
reasonable chance that some files will be corrupted.  Whether and when you
will notice is impossible to guess.

NeilBrown

> 
> 
> Thank for any advices,
> 
> Cheers,
> 

