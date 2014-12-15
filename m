From: =?UTF-8?Q?Csord=C3=A1s_Csaba?= <cscsordas@gmail.com>
Subject: Re: RAID1 + power fail + unwanted activation
Date: Mon, 15 Dec 2014 15:19:02 +0100
Message-ID: <CABpXQ7Z_bLstc2Aj=hGpQffSJJKaC+tYY5=eLM7JuG-4QrwTXQ@mail.gmail.com>
References: <CABpXQ7bb4Sz7DZshAsry_+XO1x0p3jaSR3diYNj3t3CqCYV5pA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABpXQ7bb4Sz7DZshAsry_+XO1x0p3jaSR3diYNj3t3CqCYV5pA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Although there still isn't any reactions I am still patient in order
to fully recover things. I'm open to anything, including telling me if
my questions are stupid or not understandable. Since my _previous_
notes about md and mdadm were on the RAID, I am stuck. I just won't
touch it until it will be clear for me. Also, I just can mount both
filesystems and run a diff -r against them hoping it results a 100%
match, and then recreate the RAID from scratch. It is soooo miserable,
isn't it?

The hard part is that presumably I don't understand something (:D) and
I don't know anybody else not amongst you who might know md better.
Since unfortunately I am not "used to" read C source code, any pointer
from remarkable people would be helpful.


Csord=C3=A1s Csaba


On Wed, Dec 3, 2014 at 5:20 PM, Csord=C3=A1s Csaba <cscsordas@gmail.com=
> wrote:
> Hi,
>
> after a power fail I was afraid so I was thinking about making a full
> gzipped image with dd from both members of my level1 array to be able
> to go back to the "original" (before the crash) state in case if
> *something* goes wrong during rebuild/lvm activation/fsck.
>
> The other machine I put the disk in unfortunately also had mdadm
> installed which automatically activated the degraded array (only one
> member of the array was connected) at boot time.
>
> Now, if i just put the disks back in the crashed machine, will the
> right thing happen while the kernel is resyncing the blocks between
> the devices? The internal bitmap was turned on, but the event counter
> on the mistakenly activated member of the array might have changed. I
> don't know how this -or other things I am not aware of- relates to th=
e
> actual reassembly of my RAID1 array. I'm looking for an authoritative
> answer to understand the situation.
>
>
> Csord=C3=A1s Csaba
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
