From: Chris Worley <worleys@gmail.com>
Subject: Re: Load-balancing mirrors w/ asymmetric performance
Date: Mon, 12 Oct 2009 09:00:03 -0600
Message-ID: <f3177b9e0910120800y56d01e77u50c95c918e02d602@mail.gmail.com>
References: <f3177b9e0910041240h4dba8771vb5ba07216c9c8189@mail.gmail.com>
	 <170fa0d20910120722o2347f119g9e3c48b52bc4efef@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <170fa0d20910120722o2347f119g9e3c48b52bc4efef@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@gmail.com>
Cc: linuxraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Oct 12, 2009 at 8:22 AM, Mike Snitzer <snitzer@gmail.com> wrote=
:
> On Sun, Oct 4, 2009 at 3:40 PM, Chris Worley <worleys@gmail.com> wrot=
e:
>> When you mirror two devices, they may not have the same performance.
>> For example, if one device is local and the other remote.
>>
>> There's nothing you can do about writes, as everything needs written=
=2E
>>
>> But, reads shouldn't be split 50/50: they should be balanced dependi=
ng
>> relative performance of each mirror to optimize overall read
>> performance.
>
> And MD already has the ability to flag the slow paths as write-mostly=
, see:
>
> mdadm ... --write-mostly
>
> There is also '--write-behind' support for devices that have been
> tagged as 'write-mostly'.

Will "write-mostly" optimize the "read", such that both devices will
be accessed in proportion to their performance?

The man page says:

"...and means that the =92md=92 driver will avoid reading from these
devices if at all possible."

Even a slow device can take some of the load and increase performance.

Thanks,

Chris
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
