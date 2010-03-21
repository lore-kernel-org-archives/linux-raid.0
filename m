From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Problem converting from raid5 to raid6
Date: Sun, 21 Mar 2010 03:28:48 -0700
Message-ID: <4877c76c1003210328s313155c5u7c6e829d33f38abe@mail.gmail.com>
References: <20100321030107.GA18586@csy.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100321030107.GA18586@csy.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Shane W <shane-kernel@csy.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Mar 20, 2010 at 8:01 PM, Shane W <shane-kernel@csy.ca> wrote:
> Hello all,
>
> I am trying to convert a 5 disk raid5 array to a 6 disk
> raid6 but am having no luck. I first added the 6th disk as
> a spare then
> mdadm --grow /dev/md3 --level 6
> mdadm level of /dev/md3 changed to raid6
> mdadm: /dev/md3: Something wrong - reshape aborted
> mdadm: aborting level change
>
> dmesg doesn't show an error and neither does mdadm beyond
> "something wrong". Is this supported?
>
> mdadm 3.1.1 Linux 2.6.32.8 x86_64.
>
> Thanks,
> Shane
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

It should be supported, but you probably need to specify a temporary
file ON ANOTHER DEVICE where the 'critical section' can be backed up
to and restored in case the reshape fails.  I forget what the exact
syntax is, but man mdadm will inform you.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
