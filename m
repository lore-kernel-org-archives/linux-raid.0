From: Jan Ceuleers <jan.ceuleers@computer.org>
Subject: Re: Converting system to raid
Date: Sat, 11 Apr 2009 09:48:13 +0200
Message-ID: <49E04B3D.3010308@computer.org>
References: <003801c9b96d$21a0f420$0a00a8c0@vorg> <20090410132233.GA15442@cthulhu.home.robinhill.me.uk> <008001c9ba12$3ac92c10$0a00a8c0@vorg> <20090410195006.GA21242@cthulhu.home.robinhill.me.uk> <Pine.LNX.4.61.0904110035420.6312@soloth.lewis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0904110035420.6312@soloth.lewis.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jon Lewis wrote:
> Can you cite an example of a file that can't be copied on a "running 
> system?"

All files that are open for writing at the time of the copy risk being 
copied incompletely. Use lsof to find them (but that's a snapshot).

> Sure, there are issues if the system is really up and running multi-user 
> with log files that will be copied partially and probably end up 
> terminated with extra nulls, database files may have issues (i.e. mysql 
> if you don't flush and lock the tables, copied tables will be corrupt 
> but are usually trivially repairable), but I've never heard of files not 
> being at all readable.

I submit that these issues, even if you regard them as trivially 
repairable, are best avoided altogether by making the copy while the 
filesystem is not in use. And "trivially repairable" presupposes that 
you know that there is something to be repaired in the first place, and 
then that you know how to do it. Some of these issues may not manifest 
themselves until some time after you've begun using the flawed clone, at 
which time you may have forgotten all about this, may no longer have 
access to the original data etc.

To the OP: if you want to limit downtime resulting from the fact that 
the clone has to be made while the filesystem is not in use, you can use 
rsync to make your copy while the filesystem is still in use (but this 
copy will be incomplete/flawed etc), and then use rsync again after 
you've booted from a CD or whatever. The second rsync run will be much 
faster because it will only copy the files that have changed since the 
first run, including those that were open at the time of the first run.

Cheers, Jan
