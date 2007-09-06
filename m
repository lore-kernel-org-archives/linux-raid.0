From: Neil Brown <neilb@suse.de>
Subject: Re: RAID 6 reshape failed (false message about critical section)
Date: Thu, 6 Sep 2007 06:12:22 +0100
Message-ID: <18143.35894.229908.536924@notabene.brown>
References: <515CA0AD-2BAF-437A-8A41-260F7A27BADB@harekrishna.ru>
	<18142.41665.719883.549678@notabene.brown>
	<62E93D27-4D05-45F7-BB60-144BA46DC913@harekrishna.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Anton Voloshin on Wednesday September 5
Sender: linux-raid-owner@vger.kernel.org
To: Anton Voloshin <ashutosh@harekrishna.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday September 5, ashutosh@harekrishna.ru wrote:
> Dear Neil,
> 
> > I can see what the problem is.  It will take a little while to figure
> > out what the "correct" fix it, but a quick fix to get you out of
> > trouble would be to remove the lines:
> >
> > 		if (info->array.utime > __le64_to_cpu(bsb.mtime) + 3600 ||
> > 		    info->array.utime < __le64_to_cpu(bsb.mtime))
> > 			continue; /* time stamp is too bad */
> 
> I've applied the patch that you suggested but I'm getting exactly the  
> same result:
> 
> > root@videoserver:~/mdadm-2.6.3# ./mdadm --assemble /dev/md1
> > mdadm: Failed to restore critical section for reshape, sorry.
> 
> Please advise me on any more information that I should provide or  
> make any other suggestions/advices.
> 

At the top of Grow_restart (in Grow.c), just put
	return 0;

That will definitely get you your array back.
I think the correct fix will be to put:

    if (info->reshape_progress > SOME_NUMBER)
	return 0;

at the top of Grow_restart.  I just have to review exactly how it
works to make sure I pick the correct "SOME_NUMBER".

Also
		if (__le64_to_cpu(bsb.length) <
		    info->reshape_progress)
			continue; /* No new data here */

might need to become
		if (__le64_to_cpu(bsb.length) <
		    info->reshape_progress)
			return 0; /* No new data here */

but I need to think carefully about that too.

NeilBrown
