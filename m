From: "Paul M." <paul@gpmidi.net>
Subject: Re: how to clone a disk
Date: Sat, 11 Mar 2006 06:53:17 -0500
Message-ID: <dd43dcfb0603110353g1a4d51f6y9fe4caa4007b6e9c@mail.gmail.com>
References: <1142038562.20484.234.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1142038562.20484.234.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: mingz@ele.uri.edu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Since its raid5 you would be fine just pulling the disk out and
letting the raid driver rebuild the array. If you have a hot spare
then that disk will automatically take over when you remove the
failing disk.
It would also be reasonable to simply wait for the disk to fail. When
that happens the array will be keep running. When the disk does fail
the system will use the hot spare to rebuild the array.
The short answer is your way will work but it not necessarily.
-Paul

On 3/10/06, Ming Zhang <mingz@ele.uri.edu> wrote:
> Hi folks
>
> I have a raid5 array that contain 4 disk and 1 spare disk. now i saw one
> disk have sign of going fail via smart log.
>
> so i am trying to do this
>
> 1) pull that disk (A) out
> 2) using dd to copy that disk (A) to another same one (B);
> 3) put disk (B) back to raid5 and assume that bitmap can help me resync
> quickly.
>
> now my question is
> 1) can this achieve my goal?
> 2) is there any better/correct way?
>
> thanks!
>
> Ming
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
