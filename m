From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: mdadm file system type check
Date: Sat, 17 Mar 2007 13:10:51 -0500
Message-ID: <45FC2F2B.7070506@tmr.com>
References: <1174089424.22511.26.camel@wlt.obsidian-studios.com>	 <17915.17571.333717.668140@notabene.brown> <1174099334.13073.46.camel@wlt.obsidian-studios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1174099334.13073.46.camel@wlt.obsidian-studios.com>
Sender: linux-raid-owner@vger.kernel.org
To: "William L. Thomson Jr." <wltjr@gentoo.org>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

William L. Thomson Jr. wrote:
> On Sat, 2007-03-17 at 12:30 +1100, Neil Brown wrote:
>   
>> It would be very awkward for mdadm to get at the partition type
>> information. 
>> And there is very little software that actually cares.  mdadm
>> certainly doesn't care what the partition type is.
>>     
>
> I got it reversed. :) There was an error when the file system was not
> linux auto raid. More on that below.
>
>   
>> I don't understand why you would have to 'start over'.  If you
>> discover that the partition type isn't what you want for some reason,
>> just change it.
>>     
>
> It might have been that simple, it was quite some time ago. But it was a
> memorable event since it stuck in my head as one of the things to check
> when having problems with mdadm. But obviously not a clear memory.
>
>   
>> This is the right place, thanks.
>>     
>
> Good to know ;)
>
>   
>> But maybe I don't really understand what the problem is.
>> Could you give more details?  Exactly what didn't work the way you
>> expected it to?
>>     
>
> Instead of passing along an interpretation, here are some IRC log
> snippets that pertain from #gentoo-dev @ freenode.net
>
> kingtaco|work: livecd ~ # mdadm --create --level=1 --raid-devices=2 /dev/md0 /dev/sda1 /dev/sdb1
> kingtaco|work: mdadm: /dev/sda1 is too small: 0K
> kingtaco|work: mdadm: create aborted
>
> Now despite suggesting it pretty early on, it took a bit of time to
> realize that error was existing only because of file system type. Once
> he realized the problem and changed fs type. All was well, and he was
> able to create the arrays and move on.
>   
First, please learn the difference between file system type (user data 
ON the device), and partition type (a byte in the partition table). It 
will at least let people understand your question...

Second, mdadm cares not a bit about the partition type, although some 
init scripts might. The reason it didn't work was because the partition 
was zero size or missing, and would not work regardless of the partition 
type.
> kingtaco|work: wltjr, see, raidtools would have let me create an array eventhough the type wasn't fs
> kingtaco|work: er, fd
> kingtaco|work: mdadm just isn't that smart
> kingtaco|work: (and that fixed it)
>
> So ot to sure about the error or why they would get that just because of
> file system type.
>
>   
If raidtools creates or resizes partitions, that's certainly not 
documented, nor is it in any way "smart," since it's guessing what you 
want to do and where you want to do it.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

