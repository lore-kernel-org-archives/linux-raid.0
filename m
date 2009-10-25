From: Christopher Chen <muffaleta@gmail.com>
Subject: Re: Is My Data DESTROYED?!
Date: Sun, 25 Oct 2009 11:12:56 -0700
Message-ID: <7bc80d500910251112h5b2fe24bp578e6ebcb5336582@mail.gmail.com>
References: <20091025133858.GA23319@boogie.lpds.sztaki.hu>
	 <56508.9205.qm@web38802.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56508.9205.qm@web38802.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: adfas asd <chimera_god@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Oct 25, 2009 at 8:47 AM, adfas asd <chimera_god@yahoo.com> wrot=
e:
> --- On Sun, 10/25/09, Gabor Gombas <gombasg@sztaki.hu> wrote:
>> > I am shocked at all who think that human error is so
>> prevalent, and in
>> > fact obviates the case for RAID as backup. =A0I've
>> run Debian for 12
>> > years on all my personal servers and remember
>> literally only 3 or 4
>> > cases in that time where I muggered something up and
>> had to go to
>> > backup. =A0There must be alot of fsckups out
>> there...
>>
>> Again, RAID is _not_ backup. "Backup" is something that can
>> retrieve a
>> file if you've deleted it or if you've accidentally
>> overwritten it. RAID
>> cannot do that.
>
> You are not understanding the words what are coming out of my mouf...

Yes, it's true. You're asking for a magic solution that gives you data
security and performance with a full audit path that alerts you if
anything goes wrong.

There exist technologies that allow for real-time off-machine
replication, but I think what all the other sysadmins on the list
(which, mind you, have worked longer than you, and have experience
with larger installations than you) are trying to tell you something.
People on this list have spent hours responding to this one thread,
and a few of them have written you off.

RAID will only save you from a set of hardware failures. These are a
cause of concern but as Leslie has rightfully said, they will not
protect you against software bugs or user error, which is a primary
cause of concern.

I think you should do both. You should do some sort of fault tolerant
RAID on your primary HTPC, a simple mirror, or a RAID 10 of 4 drives.

You should also back up that data with a system that runs on a regular
basis, but NOT in real-time, because what would happen is you'd
accidentally delete a file, and poof!, the deletion is replicated to
the other machine. Not very useful.

>
>
>> > Now a backup by cron is nice and all, but what if it
>> silently fails in
>> > some obscure way?
>>
>> There are a couple of golden rules about backups. One such
>> rule is that
>> you should check at regular intervals that your backup is
>> intact,
>
> LOL
> For terabytes? =A0Get real.

Sir, we are real. People are doing this every day on data sets
hundreds of times larger than yours, with real data, and are
professionally responsible for it. If you fail to see that, I don't
know what to say.

>
>
>> > This is one thing I like about RAID or ZFS, it lets
>> > you know when anything's wrong.
>>
>> No. They let you know when a limited set of errors
>> conditions occur.
>> Neither RAID nor ZFS will complain if you delete the wrong
>> file or if
>> you accidentally overwrite the show you've recorded
>> yesterday. A good
>> backup solution protects you from both.
>
> Again, you are not understanding.

Yeah, you're probably right. I'm done.

cc

--=20
Chris Chen <muffaleta@gmail.com>
"The fact that yours is better than anyone else's
is not a guarantee that it's any good."
-- Seen on a wall
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
