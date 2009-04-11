From: Jon Lewis <jlewis@lewis.org>
Subject: Re: Converting system to raid
Date: Sat, 11 Apr 2009 00:40:37 -0400 (EDT)
Message-ID: <Pine.LNX.4.61.0904110035420.6312@soloth.lewis.org>
References: <003801c9b96d$21a0f420$0a00a8c0@vorg>
 <20090410132233.GA15442@cthulhu.home.robinhill.me.uk> <008001c9ba12$3ac92c10$0a00a8c0@vorg>
 <20090410195006.GA21242@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090410195006.GA21242@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Hill <robin@robinhill.me.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 10 Apr 2009, Robin Hill wrote:

> On Fri Apr 10, 2009 at 12:22:44PM -0700, Timothy D. Lenz wrote:
>
>> How can cp not work? every guide I found used ether cp or rsync. Even
>> guides on seting up an auto backup system use cp or rsync.
>> Seems the only files/folders that shouldn't get copied are the block
>> device ones that are created at boot and are not really on the drive.
>>
> They'll all get copied, but you won't necessarily get the correct
> contents.  Because the system is in use:
> - files will be being written, so you'll either get a partial copy, or
>   an old version.
> - files may be locked, so you won't be able to copy them.
>
> Doing a backup of a running system using cp/rsync will work fine for a
> lot of things (especially for config files, documents, etc) but will
> almost certainly fail miserably for some (databases for example).

Can you cite an example of a file that can't be copied on a "running 
system?"

Sure, there are issues if the system is really up and running multi-user 
with log files that will be copied partially and probably end up 
terminated with extra nulls, database files may have issues (i.e. mysql if 
you don't flush and lock the tables, copied tables will be corrupt but are 
usually trivially repairable), but I've never heard of files not being at 
all readable.

The idea that "it just won't work because critical files are locked" 
sounds like Windows talk.

----------------------------------------------------------------------
  Jon Lewis                   |  I route
  Senior Network Engineer     |  therefore you are
  Atlantic Net                |
_________ http://www.lewis.org/~jlewis/pgp for PGP public key_________
