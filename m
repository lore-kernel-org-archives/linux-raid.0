From: Aapo Laine <aapo.laine@shiftmail.org>
Subject: Re: potentially lost largeish raid5 array..
Date: Sun, 02 Oct 2011 01:21:18 +0200
Message-ID: <4E87A06E.6080109@shiftmail.org>
References: <201109221950.36910.tfjellstrom@shaw.ca>
 <20110923151108.08c1199f@notabene.brown>
 <201109222322.57040.tfjellstrom@shaw.ca>
 <201109230209.36209.thomas@fjellstrom.ca>
 <20110923191539.110b7be1@notabene.brown> <4E7E5266.5040205@shiftmail.org>
 <20110925201025.53bc87f7@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20110925201025.53bc87f7@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Excuse the late reply

On 09/25/11 12:10, NeilBrown wrote:
> On Sat, 24 Sep 2011 23:57:58 +0200 Aapo Laine<aapo.laine@shiftmail.org>
> wrote:
> Hopefully not too shocking...  I'm not planning on leaving md any time soon.
> I do still enjoy working on it.
> But it certainly isn't as fresh and new as it was 10 years again.  It would
> probably do both me and md a lot of good to have someone with new enthusiasm
> and new perspectives...

I understand

> ....
> That is certainly true, but seems to be true across much of the kernel, and
> probably most code in general (though I'm sure such a comment will lead to
> people wanting to tell me their favourite exceptions ... so I'll start with
> "TeX").
>
> This is one of the reasons I offered "mentoring" to any likely candidate.
>
>
>
>> - there is not much explanation of overall strategies, or the structure
>> of code. Also the flow of data between the functions is not much
>> explained most of the times.
>>
>> - It's not obvious to me what is the entry point for kernel processes
>> related to MD arrays, how are they triggered and where do they run...
>> E.g. in the past I tried to understand how did resync work, but I
>> couldn't. I thought there was a kernel process controlling resync
>> advancement, but I couldn't really find the boundaries of code inside
>> which it was executing.
> md_do_sync() is the heart of the resync process.  it calls into the
> personality's sync_request() function.
>
> The kernel thread is started by md_check_recovery() if it appears to be
> needed.  md_check_recovery() is regularly run by each personality's main
> controlling thread.
>
>> - it's not clear what the various functions do or in what occasion they
>> are called. Except from their own name, most of them have no comments
>> just before the definition.
> How about this:
>   - you identify some functions for which the purpose or use isn't clear
>   - I'll explain to you when/how/why they are used
>   - You create a patch which adds comments which explains it all
>   - I'll apply that patch.
>
> deal??

I would never dare to commit your comments back to you with my name, not 
even if you ask me to do so :-)

But thanks for offering to explain the things.
If you do this on the mailing list everybody is going to read that and 
this will be useful to everybody.

Actually we could even open a new mailing list or maybe there is 
something better in web 2.0, like a wiki, for these MD code 
explanations. Explanations in a wiki can be longer, there can be user 
discussions, and such lines of comments do not need to be pushed as far 
as Linus.


>> - the algoritms within the functions are very long and complex, but only
>> rarely they are explained by comments. I am now seeing pieces having 5
>> levels of if's nested one inside the other, and there are almost no
>> comments.
> I feel your pain.   I really should factor out the deeply nested levels into
> separate functions.  Sometimes I have done that but there is plenty more do
> to.  Again, I would be much more motivated to do this if I were working with
> someone who would be directly helped by it.  So if you identify specific
> problems, it'll be a lot easier for me to help fix them.

Well in fact I am not against deeply nested code, actually I am more 
against functions which are called from one point only, because this 
disrupts reading flow greatly.
But what I wanted to say was that if nesting level is 5 it means that 
this is complex code so more comments are always appreciated.


>> - last but not least, variables have very short names, and for most of
>> them, it is not explained what they mean. This is mostly for local
>> variables, but sometimes even for the structs which go into metadata
>> e.g. in struct r1_private_data_s most members do not have an
>> explanation. This is pretty serious, to me at least, for understanding
>> the code.
> Does this help?
>
> diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
> index e0d676b..feb44ad 100644
> --- a/drivers/md/raid1.h
> +++ b/drivers/md/raid1.h
> @@ -28,42 +28,67 @@ struct r1_private_data_s {
>   	mddev_t			*mddev;
>   	mirror_info_t		*mirrors;
>   	int			raid_disks;
> +
> +	/* When choose the best device for a read (read_balance())
> +	 * we try to keep sequential reads one the same device
> +	 * using 'last_used' and 'next_seq_sect'
> +	 */
>   	int			last_used;
>   	sector_t		next_seq_sect;
> +	/* During resync, read_balancing is only allowed on the part
> +	 * of the array that has been resynced.  'next_resync' tells us
> +	 * where that is.
> +	 */
> +	sector_t		next_resync;
> +
>   	spinlock_t		device_lock;
>
> +	/* list of 'r1bio_t' that need to be processed by raid1d, whether
> +	 * to retry a read, writeout a resync or recovery block, or
> +	 * anything else.
> +	 */
>   	struct list_head	retry_list;
> -	/* queue pending writes and submit them on unplug */
> -	struct bio_list		pending_bio_list;
>
> -	/* for use when syncing mirrors: */
> +	/* queue pending writes to be submitted on unplug */
> +	struct bio_list		pending_bio_list;
>
> +	/* for use when syncing mirrors:
> +	 * We don't allow both normal IO and resync/recovery IO at
> +	 * the same time - resync/recovery can only happen when there
> +	 * is no other IO.  So when either is active, the other has to wait.
> +	 * See more details description in raid1.c near raise_barrier().
> +	 */
> +	wait_queue_head_t	wait_barrier;
>   	spinlock_t		resync_lock;
>   	int			nr_pending;
>   	int			nr_waiting;
>   	int			nr_queued;
>   	int			barrier;
> -	sector_t		next_resync;
> -	int			fullsync;  /* set to 1 if a full sync is needed,
> -					    * (fresh device added).
> -					    * Cleared when a sync completes.
> -					    */
> -	int			recovery_disabled; /* when the same as
> -						    * mddev->recovery_disabled
> -						    * we don't allow recovery
> -						    * to be attempted as we
> -						    * expect a read error
> -						    */
>
> -	wait_queue_head_t	wait_barrier;
> +	/* Set to 1 if a full sync is needed, (fresh device added).
> +	 * Cleared when a sync completes.
> +	 */
> +	int			fullsync
>
> -	struct pool_info	*poolinfo;
> +	/* When the same as mddev->recovery_disabled we don't allow
> +	 * recovery to be attempted as we expect a read error.
> +	 */
> +	int			recovery_disabled;
>
> -	struct page		*tmppage;
>
> +	/* poolinfo contains information about the content of the
> +	 * mempools - it changes when the array grows or shrinks
> +	 */
> +	struct pool_info	*poolinfo;
>   	mempool_t *r1bio_pool;
>   	mempool_t *r1buf_pool;
>
> +	/* temporary buffer to synchronous IO when attempting to repair
> +	 * a read error.
> +	 */
> +	struct page		*tmppage;
> +
> +
>   	/* When taking over an array from a different personality, we store
>   	 * the new thread here until we fully activate the array.
>   	 */

YES!
thanks

>
> I'm not planning on leaving - not for quite some time anyway.
> But I know the code so well that it is hard to see which bits need
> documenting, and what sort of documentation would really help.
> I would love it if you (or anyone) would review the code and point to parts
> that particularly need improvement.

I don't have much time to dedicate to this but if I come across 
something not clear I will ask, now that I know I can.
Other people hopefully would do the same so that I don't feel too stupid.

I think concentrating all code explanation requests, discussions, and/or 
at least the answers, onto something like a wiki could prevent 
double-questions. Unfortunately I know nothing about wikis or other web 
2.0 technologies. Maybe someone in this ML can suggest a solution?


> ...
> Thanks for your valuable feedback.
> Being able to see problems is of significant value.  One of the reasons that
> I pay close attention to this list is because it shows me where the problems
> with md and mdadm are.  People often try things that I would never even dream
> of trying (because I know they won't work).  See this helps me know where the
> code and be improved - either so what they try does work, or so it fails more
> gracefully and helpfully.

I understand
Thanks for your time, really

