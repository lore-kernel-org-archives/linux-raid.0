From: Dragos <dragos@mpigani.org>
Subject: Re: assemble vs create an array.......
Date: Sun, 03 Feb 2008 02:42:14 -0500
Message-ID: <47A57056.5070904@mpigani.org>
References: <474F869D.5040503@mpigani.org> <18255.41044.614676.410107@notabene.brown> <47501D7E.7000804@dgreaves.com> <475552D2.4000802@mpigani.org> <47568DE1.1050108@dgreaves.com> <4758129D.40600@mpigani.org> <475825C0.4070605@msgid.tls.msk.ru> <20071206212225.GN115527101@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071206212225.GN115527101@sgi.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Chinner <dgc@sgi.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, David Greaves <david@dgreaves.com>, linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids

Hello,
I am not sure if you have received my email from last week with the 
results of the different combinations prescribed (it contained html code).
Anyway, I did a ro mount to check the partition and was happy to see a 
lot of files intact. A few seemed destroyed, but I am not sure. I tried 
a xfs_check on the partition and it told me:

ERROR: The filesystem have valuable metadata changes in a log which 
needs to be replayed. Mount the filesystem to replay the log, and 
unmount it before re-running xfs_check. If you are unable to mount the 
filesystem, then use the xfs_repair -L option to destroy the log and 
attempt a repair.

Since I am unable to mount the partition, shoud I use the -L option with 
xfs_repair, or let it run without it?
Again, please let me know if I should resend my previous email with the 
log file of "xfs_repair -n".

Thank you for your time,
Dragos


David Chinner wrote:
> On Thu, Dec 06, 2007 at 07:39:28PM +0300, Michael Tokarev wrote:
>   
>> What to do is to give repairfs a try for each permutation,
>> but again without letting it to actually fix anything.
>> Just run it in read-only mode and see which combination
>> of drives gives less errors, or no fatal errors (there
>> may be several similar combinations, with the same order
>> of drives but with different drive "missing").
>>     
>
> Ugggh. 
>
>   
>> It's sad that xfs refuses mount when "structure needs
>> cleaning" - the best way here is to actually mount it
>> and see how it looks like, instead of trying repair
>> tools. 
>>     
>
> It self protection - if you try to write to a corrupted filesystem,
> you'll only make the corruption worse. Mounting involves log
> recovery, which writes to the filesystem....
>
>   
>> Is there some option to force-mount it still
>> (in readonly mode, knowing it may OOPs kernel etc)?
>>     
>
> Sure you can: mount -o ro,norecovery <dev> <mtpt>
>
> But it you hit corruption it will still shut down on you. If
> the machine oopses then that is a bug.
>
>   
>> thread prompted me to think.  If I can't force-mount it
>> (or browse it using other ways) as I can almost always
>> do with (somewhat?) broken ext[23] just to examine things,
>> maybe I'm trying it before it's mature enough? ;)
>>     
>
> Hehe ;)
>
> For maximum uber-XFS-guru points, learn to browse your filesystem
> with xfs_db. :P
>
> Cheers,
>
> Dave.
>   
