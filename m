From: "Chris Evans" <chris1@psyctc.org>
Subject: Re: md: can not impport hdb1, has active inodes!
Date: Wed, 03 Mar 2004 01:13:54 -0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40453152.462.2FC95FD@localhost>
References: <16453.12057.827300.308373@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <16453.12057.827300.308373@notabene.cse.unsw.edu.au>
References: message from Chris Evans on Wednesday March 3
To: debian-user@lists.debian.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3 Mar 2004 at 12:04, Neil Brown wrote:

> > > You missed a step (step 9).  You have to reboot so that /dev/md0
> > > is your root device. Once you have done that and are happy with
> > > it, you add in /dev/hdb1 and let it resync.
> > Ditto: did that, no go.
> 
> Sorry, I missed where you said that you rebooted.
you are correct: I didn't say that, but I have done!
 
> It sounds very odd.
Well, I thought so too, but I see I'm not alone in experiencing this.

> What does "cat /proc/mounts" say?
Aha, didn't know that wrinkle: lovely.  Mount says:
/dev/md0 on / type ext3 (rw,errors=remount-ro)
proc on /proc type proc (rw)
devpts on /dev/pts type devpts (rw,gid=5,mode=620)

and cat /proc/mounts says:
rootfs / rootfs rw 0 0
/dev/root / ext2 rw 0 0
proc /proc proc rw 0 0
devpts /dev/pts devpts rw 0 0

Does that "/dev/root" bit indicate anything useful?

> Does your kernel use an initrd?
No, at least, I haven't asked it to!
 
> Exactly how did you tell lilo to use /dev/md0?
> With
>    root=/dev/md0
> as an option in lilo.conf, or with
>    append= "root=/dev/md0"

I think I've only tried the former (with and without an earlier line, 
before the image stanzas, saying root=/dev/hdb1)

I haven't used an "append" clause anywhere.

One problem is keeping in mind which of the lilo.conf tweaks 
installed with lilo but didn't solve the problem, and which were the 
ones that lilo refused to install.

I'm happy to try alternatives and report effects, on or off list, of 
each.

Many thanks,

Chris



> 
> or both or something else?
> 
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html

PSYCTC: Psychotherapy, Psychology, Psychiatry, Counselling
   and Therapeutic Communities; practice, research, 
   teaching and consultancy.
Chris Evans & Jo-anne Carlyle
http://psyctc.org/ Email: chris@psyctc.org

