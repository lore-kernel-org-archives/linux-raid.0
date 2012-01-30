From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Subject: Re: Reduce number of active RAID1 devices
Date: Mon, 30 Jan 2012 13:53:39 -0500
Message-ID: <CALJXSJrYTuMRYfho05XXMFX0e1hekbm5BUtA5EhhO1HmOiBeig@mail.gmail.com>
References: <4F26E401.6000205@computer.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F26E401.6000205@computer.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Ceuleers <jan.ceuleers@computer.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 30, 2012 at 1:40 PM, Jan Ceuleers <jan.ceuleers@computer.or=
g> wrote:
>
> md0 : active raid1 sdb2[3] sde1[2] sdd1[0]
> =C2=A0 =C2=A0 =C2=A0521984 blocks [4/3] [U_UU]

You must first fail and remove a device from the array, reduce to 2
components and add back the spare which will appear as sdxN (S). You
can do this online.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
