From: "Chris Evans" <chris1@psyctc.org>
Subject: Re: md: can not impport hdb1, has active inodes!
Date: Wed, 03 Mar 2004 00:36:27 -0000
Message-ID: <4045288B.27321.2DA4EF3@localhost>
References: <16453.6996.215724.636242@notabene.cse.unsw.edu.au>
Return-path: <bounce-debian-user=debian-user=quimby.gnus.org@lists.debian.org>
In-reply-to: <16453.6996.215724.636242@notabene.cse.unsw.edu.au>
References: message from Chris Evans on Tuesday March 2
Resent-Message-ID: <Kbb30C.A.2wC.yiSRAB@murphy>
List-Post: <mailto:debian-user@lists.debian.org>
List-Help: <mailto:debian-user-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-user-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-user-request@lists.debian.org?subject=unsubscribe>
List-Archive: <http://lists.debian.org/debian-user/>
To: debian-user@lists.debian.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3 Mar 2004 at 10:40, Neil Brown wrote:

> Wrong.
>  mkfs -t ext3 /dev/md0
> then mount /dev/md0. 
> Once you have included /dev/hdc1 in an array, don't touch it again -
> just access the array (/dev/md0).

Sorry, I was being hasty in writing the Email, that's what I did, 
i.e. mkfs the /dev/md0 drive.  That's not the problem.

> You missed a step (step 9).  You have to reboot so that /dev/md0 is
> your root device. Once you have done that and are happy with it, you
> add in /dev/hdb1 and let it resync.
Ditto: did that, no go.

Thanks,

C
PSYCTC: Psychotherapy, Psychology, Psychiatry, Counselling
   and Therapeutic Communities; practice, research, 
   teaching and consultancy.
Chris Evans & Jo-anne Carlyle
http://psyctc.org/ Email: chris@psyctc.org
