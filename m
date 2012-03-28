From: John Obaterspok <john.obaterspok@gmail.com>
Subject: Re: Hints on reducing kickouts
Date: Wed, 28 Mar 2012 22:11:58 +0200
Message-ID: <CAOscVd+VR=PPhBKhpMFSVWOn-y+fOuJzxq6RMYAeSLf-0W4hAw@mail.gmail.com>
References: <CAOscVd+CWwJoRknhGOvexC7w64o_5H-Q+USheTYZULJbJ8EOYA@mail.gmail.com>
	<20120301182218.GB9106@atlantis.cc.ndsu.nodak.edu>
	<CAOscVdKo6aU+H6xGfpMTdN_XCAVnF3V2XXuqN4V5rYBux3e3_Q@mail.gmail.com>
	<20120303222424.GA29339@atlantis.cc.ndsu.nodak.edu>
	<CAOscVdL_gTLVVHvFAQzv0XocDVH6t8oBSrqMQUHL5nH3vLQxgA@mail.gmail.com>
	<20120311191508.GA28110@atlantis.cc.ndsu.nodak.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120311191508.GA28110@atlantis.cc.ndsu.nodak.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Bryan Mesich <bryan.mesich@ndsu.edu>, John Obaterspok <john.obaterspok@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks Bryan,

I Appreciate it. I'll try with write intent when I get a chance (I'm
still struggeling with md).

My sdb disk got kicked out a second time in perhaps two weeks. I have
a feeling it's the sdb that gets kicked most of the time. md0 & md1
got the sdb kicked but md1 didn't. Any reasons why a disk gets kicked,
or perhaps why it gets unclean and thus kicked?

md2 : active raid5 sdc3[3] sda3[0]
      5706313728 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2=
] [U_U]

md0 : active raid1 sdc1[2] sda1[0]
      307188 blocks super 1.0 [3/2] [U_U]

md1 : active raid5 sdb2[4] sdc2[3] sda2[0]
      153596928 blocks super 1.1 level 5, 512k chunk, algorithm 2 [3/3]=
 [UUU]
      bitmap: 0/1 pages [0KB], 65536KB chunk

--john

2012/3/11 Bryan Mesich <bryan.mesich@ndsu.edu>:
> On Sun, Mar 11, 2012 at 07:55:10PM +0100, John Obaterspok wrote:
>> Hello,
>>
>> mdadm --grow /dev/md2 --bitmap=3Dinternal
>> mdadm: failed to set internal bitmap.
>>
>> I then tried it on md1 and this crashed my machine. (bitmap_endwrite
>> <- handle_stripe)
>> hmm.
>>
>> I don't know what to do.
>
> This looks like a bug that Neil commented about last week (I
> deleted the thread, so can't directly forward it to you).
> The thread I'm referring to can be found here:
>
> http://marc.info/?t=3D133122326800004&r=3D1&w=3D2
>
> Subject of the thread is: "invalid bitmap file superblock: bad
> magic". =A0Neil indicated that the fix in included in the following
> commit:
>
> http://neil.brown.name/git?p=3Dmdadm;a=3Dcommitdiff;h=3D6ef89052d85b8=
137b8a7100f761d896ae6f61001
>
>
> Bryan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
