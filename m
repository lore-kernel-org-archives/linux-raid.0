From: Daniel Pittman <daniel@rimspace.net>
Subject: Re: Fwd: Linux MD raid5 and reiser4... Any experience ?
Date: Sun, 08 Jan 2006 13:53:07 +1100
Message-ID: <87ace7sa5o.fsf@rimspace.net>
References: <fd8d0180601050104x15079396h@mail.gmail.com>
	<fd8d0180601050106s5f5b4306o@mail.gmail.com>
	<87oe2r2d93.fsf@rimspace.net>
	<fd8d0180601050321k19f12f53r@mail.gmail.com>
	<43BE3C99.4050706@ieee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Simon Valiquette <v.simon@ieee.org> writes:
> Francois Barre a =E9crit :
>> 2006/1/5, Daniel Pittman <daniel@rimspace.net>:
>>>Francois Barre <francois.barre@gmail.com> writes:

[...]

> AFAIK, ext3 volume cannot be bigger than 4TB on a 32 bits system.  I
> think it is important you know that in case it could be a concern for
> you.

Others have pointed out that this is not correct, so I don't repeat the
reasons there.

[...]

> On production server with large RAID array, I tends to like very much
> XFS and trust it more than ReiserFS (I had some bad experience with
> ReiserFS in the past).  You can also grow a XFS filesystem live, whic=
h
> is really nice.
>
> XFS is finally much faster than EXT3 and self-defragmenting, but that
> was not a concern for you anyway.

This is true.  I wouldn't recommend, personally, using XFS on a
production machine that didn't have a very reliable UPS associated.

XFS only journals meta-data, and writes that to disk quite frequently.
It, like most other filesystems, is much more relaxed about writing the
actual data to disk.

This is great from a hard restart situation -- it means no long fsck to
get the metadata consistent.

Unfortunately, the way that XFS is put together this means that any fil=
e
that you were actively writing it in the last minute or so before an
unclean restart has a good chance of having the metadata in journal, bu=
t
the data blocks unwritten.

That will have XFS replace the file content with ASCII NULL for you --
secure, but somewhat frustrating if you just lost critical system files
as a result.[1]


Assuming that you have otherwise reliable hardware, power problems are
the most common cause of unclean restarts.  The risks of XFS data loss,
in my experience, offset the performance benefits for most production
use.

ext3, for reference, can be asked to operate in the same mode as XFS
but, by default, does not do so.

Regards,
        Daniel

=46ootnotes:=20
[1]  I may be somewhat bitter here, as I support a dozen machines that
     use XFS and are, sadly, not terribly reliable hardware.  As a
     result I spend far too much time pulling critical files back of
     backup tapes, and can look forward to that continuing until our
     migration away from that hardware is complete. :/
    =20


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
