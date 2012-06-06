From: Ole Tange <ole@tange.dk>
Subject: Re: Software RAID checksum performance on 24 disks not even close to
 kernel reported
Date: Wed, 6 Jun 2012 13:17:12 +0200
Message-ID: <CA+4vN7y+W2y2bDWu4JH9KBLD+pP6DcCdRVf7mxQ_6us5EZ5yhw@mail.gmail.com>
References: <CA+4vN7wPd0Av_sbtA0JD5y=fGcsuq20SOQVHWnE8BUFpDxOEXQ@mail.gmail.com>
 <CA+sTkh4fd+oZqagpHkGv5Kw+nkDyhunXfJm0tu0rqvuxVZBOyQ@mail.gmail.com>
 <CA+4vN7xH10qS-=OSS_3z3B3EohKHjk8-GBVvVfPj01TH-0pe3w@mail.gmail.com>
 <CA+sTkh7XeE49HmF+REyNTcOWJK6OS-tfi0qk7-SosFmAWenTqA@mail.gmail.com>
 <CA+4vN7x0f3f3=htC4iaPmDPqdviv8+AqAqY3sxKbP1X+89gtuQ@mail.gmail.com> <4FCEB515.5050209@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FCEB515.5050209@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 6, 2012 at 3:40 AM, Brad Campbell <lists2009@fnarfbargle.co=
m> wrote:
> On 06/06/12 02:44, Ole Tange wrote:
>> On Tue, Jun 5, 2012 at 1:29 PM, Igor M Podlesny<for.poige+lsr@gmail.=
com>
>> =A0wrote:
:
>>> =A0 Wanna try CONFIG_MULTICORE_RAID456? :-)
>>
>> If the kernel can checksum 6196 MB/s why would I need
>> CONFIG_MULTICORE_RAID456? Please elaborate on why you think that is
>> needed.
>
> I'd have thought there was a significant difference between the test
> generating that figure (being a large, single block being checksummed=
) and
> shunting around blocks from 20 odd block devices, arranging them and
> checksumming them.

Is this based on gut feeling? Or do you have numbers to backup this cla=
im?

> I'm not debating the validity of your tests at all, however I do ques=
tion
> your assertion than a single raid6 thread should even get close to th=
at
> theoretical figure when actually doing real work.

It would be good if we had someone who actually _knew_ (not just by
gut feeling) what the kernel reported checksumming is based on, and
how we can compute the expected performance for checksumming for a 24
disk RAID6.

=46rom the source it seems the checksumming is using 16+2 disks:

    ./lib/raid6/algos.c:	const int disks =3D (65536/PAGE_SIZE)+2;

That is fairly close to the 21+2 disks in my setup.

The chunk size seems to be 4KB:

                                (*algo)->gen_syndrome(disks, PAGE_SIZE,=
 *dptrs);

which is not close to my setup (ranging from 16KB to 4096KB).

This might mean that the only RAID6 setup in which you can expect the
checksumming performance reported by the kernel is 16+2 disks and a
chunk size of 4KB.

But if I try that setup on the test in RAM, md0_raid6 still takes up
more CPU time than the checksumming would account for.

> Why not do as the man suggested and enable CONFIG_MULTICORE_RAID456 a=
nd see
> what happens?

It is a lot of work to put into testing something that is at best a gue=
ss.

In the best case it shows that it will work with multicore, but it
would not be a solution to me (the module being experimental).

But it would be great to hear from someone who has
CONFIG_MULTICORE_RAID456 enabled already and see if they can reproduce
the results.


/Ole
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
