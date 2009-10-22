From: Lee Howard <faxguy@howardsilvan.com>
Subject: Re: [Fwd: Re: BUG: soft lockup - CPU#0 stuck for 10s! [md2_raid1:358]]
Date: Wed, 21 Oct 2009 20:27:58 -0700
Message-ID: <4ADFD13E.90900@howardsilvan.com>
References: <4ADEFFC9.10405@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4ADEFFC9.10405@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Asdo wrote:
> Lee Howard wrote:
>
>> I've been deliberately monitoring the kernel via the git web 
>> interfaces, and I can't yet see the patch committed that supposedly 
>> fixed this.  (Please correct me if it was actually committed.)
>
> Somebody told it was fixed in 2.6.32. Have you checked that one?
>
> Would you mind to explain me HOW to check such a thing via web git? I 
> wanted to do this in the past but I didn't know how to do it...

I'm not sure that I was doing it the *right* way, but go to:

http://git.kernel.org/

Click on "md raid development 
<http://git.kernel.org/?p=linux/kernel/git/djbw/md.git;a=summary>".  
Then if you look at the bottom for "master" head you'll go to this link:

http://git.kernel.org/?p=linux/kernel/git/djbw/md.git;a=shortlog;h=refs/heads/master

Then click on "tree" ( 
http://git.kernel.org/?p=linux/kernel/git/djbw/md.git;a=tree;h=refs/heads/master;hb=refs/heads/master 
) to browse the repository tree.  Dig a little further, and go to 
drivers/md and you can see the change history in the various files to 
see if a patch has been applied.

Maybe that's the wrong way to do it, but that's how I was looking.

Thanks,

Lee.


