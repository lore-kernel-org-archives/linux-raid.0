From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Backups w/ rsync
Date: Fri, 28 Sep 2007 12:25:23 -0400
Message-ID: <46FD2AF3.4040501@tmr.com>
References: <20070918230914.9FF5910215F@medulla.enet.sharplabs.com>	 <87r6knay66.fsf@informatik.uni-tuebingen.de>	 <20070925181618.82F47102162@medulla.enet.sharplabs.com>	 <87sl521kqh.fsf@informatik.uni-tuebingen.de>	 <20070925235016.02F6E1023B9@medulla.enet.sharplabs.com>	 <87k5qe19p0.fsf@informatik.uni-tuebingen.de>	 <20070927062317.3CCAB1023E0@medulla.enet.sharplabs.com>	 <46FB7D2A.1050608@ziu.info>	 <20070927221049.19BE21023EB@medulla.enet.sharplabs.com>	 <46FD1442.70707@tmr.com> <cccedfc60709280811j44d6b1c8w60e209d7c6defca9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60709280811j44d6b1c8w60e209d7c6defca9@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson@jamponi.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jon Nelson wrote:
> Please note: I'm having trouble w/gmail's formatting... so please
> forgive this if it looks horrible. :-|
>
> On 9/28/07, Bill Davidsen <davidsen@tmr.com> wrote:
>   
>> Dean S. Messing wrote:
>>     
>>> It has been some time since I read the rsync man page.  I see that
>>> there is (among the bazillion and one switches) a "--link-dest=DIR"
>>> switch which I suppose does what you describe.  I'll have to
>>> experiment with this and think things through.  Thanks, Michal.
>>>
>>>       
>> Be aware that rsync is useful for making a *copy* of your files, which
>> isn't always the best backup. If the goal is to preserve data and be
>> able to recover in time of disaster, it's probably not optimal, while if
>> you need frequent access to old or deleted files it's fine.
>>     
>
>
> You are absolutely right when you say it isn't always the best backup. There
> IS no 'best' backup.
>
> For example, full and incremental backup methods such as dump and
>   
>> restore are usually faster to take and restore than a copy, and allow
>> easy incremental backups.
>>     
>
>
> If "copy" meant "full data copy" and not "hard link where possible", I'd
> agree with you. However...
>
> I use a nightly rsync (with --link-dest) to backup more than 40 GiB to a
> drbd-backed drive. I'll explain why I use drbd in just a moment.
>
> Technically, I have a 3 disk raid5 (Linux Software Raid) which is the
> primary store for the data. Then I have a second drive (non-raid) that is
> used as a drbd backing store, which I rsync *to* from filesystems built off
> of the raid. I keep *30 days* of nightly backups on the drbd volume. The
> average difference between nightly backups is about 45MB, or a bit less than
> 10%. The total disk usage is (on average) about 10% more than a single
> backup. On an AMD x86-64 dual core (3600 de-clocked to run at 1GHz) the
> entire process takes between 1 and 2 minutes, from start to finish.
>
> Using hard links means I can snapshot ~175,000 files, about 40GiB, in under
> 2 minutes - something I'd have a hard time doing with dump+restore. I could
> easily make incremental or differential copies, and maybe even in that time
> frame, but I'm not sure I much advantage in that. Furthermore, as you state,
> dump+restore does *not* include the removal of files which for some
> scenarios is a huge deal.
>   

What I don't understand is how you use hard links... because a hard link 
needs to be in the same filesystem, and because a hard link is just 
another pointer to the inode and doesn't make a physical copy of the 
data to another device or to anywhere, really.
> The long and short of it is this: using hard links (via rsync or cp or
> whatever) to do snapshot backups can be really, really fast and have
> significant advantages but there are, as with all things, some downsides.
> Those downsides are fairly easily mitigated, however. In my case, I can lose
> 1 drive of the raid and I'm OK. If I lose 2, then the other drive (not part
> of the raid) has the data I care about. If I lose the entire machine, the
> *other* machine (the other end of the drbd, only woken up every other day or
> so) has the data. Going back 30 days. And a bare-metal "restore" is as fast
> as your I/O is.  I back my /really/ important stuff up on DLT.
>
> Thanks again to drbd, when the secondary comes up it communicates with the
> primary and is able to figure out only which blocks have changed and only
> copies those. On a nightly basis that is usually a couple of hundred
> megabytes, and at 12MiB/s that doesn't take terribly long to take care of.
>   

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

