From: Phil Turmel <philip@turmel.org>
Subject: Re: Problem halting raid 1
Date: Fri, 06 Sep 2013 07:38:01 -0400
Message-ID: <5229BE99.4070701@turmel.org>
References: <CABcjxUOszUPsEJu_nCSRwzCCy5ijs9YUb0ia8HbZ6kzW-jCwWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABcjxUOszUPsEJu_nCSRwzCCy5ijs9YUb0ia8HbZ6kzW-jCwWA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWlndWVsIENvcmJlcsOhbiBSdWl6?= <migcorrui@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning Miguel,

On 09/06/2013 06:42 AM, Miguel Corber=C3=A1n Ruiz wrote:
> Hello,
> I am having a problem stopping an array. When I use the command "mdad=
m
> --stop /dev/md0" the array disappears completely. It does not even
> appear under /dev/m..

This is the expected behavior.

> Then, when I try "mdadm --remove /dev/md0" bash tells me that /dev/md=
0
> does not exist. So, after stopping the array with "mdadm --stop ..",
> "cat /proc/mdstat" says that there is no array running. From what I
> read the array should be visible but in a halted/stopped/deactivated
> state. And then one can proceed to remove it.

The --remove action is used to remove a failed member from an array, no=
t
an array itself.

> What I want to do is to completely remove the array so I can mount th=
e
> individual partitions anywhere else without the need of mdadm (and
> access the data created when the array was running).

You would use --zero-superblock on each member device to make it
"forget" what array it belonged to.

HTH,

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
