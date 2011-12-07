From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: need a little help rebuilding a raid 10
Date: Tue, 6 Dec 2011 20:35:14 -0500
Message-ID: <CAGpXXZKRv+s_U0kBqGGEhYfazmo3obVB1nrko1du2YmN68967Q@mail.gmail.com>
References: <CAGpXXZKdbs+Y3qNHnVmFGB3sKE5R7viRajrVM+udUqoDgsA0yg@mail.gmail.com>
 <CAGpXXZKWB7qpRtWK7GuohuF-OOuAGQ_tSODCnLCouS+Z-SWZDA@mail.gmail.com> <4EDE2C1B.8000008@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EDE2C1B.8000008@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

All,

I found a fan that wasn't working.

This is 1u rack mount unit, so that fan not working apparently caused
a lot of issues.

I replaced the fan about 10 hours ago and I've done a bunch of
different tests today.  No disk errors reported in that time.

I gave up on my previous array.  I just deleted it and recreated it.

I'm restoring from backup now.

Thanks
Greg

On Tue, Dec 6, 2011 at 9:52 AM, Phil Turmel <philip@turmel.org> wrote:
> Hi Greg,
>
> On 12/06/2011 09:11 AM, Greg Freemyer wrote:
>> Hmm...
>>
>> My rebuild failed. =A0At first glance I had both a failed drive and =
a failed slot?
>>
>> What I don't understand is I have I/O errors in /var/log/messages fr=
om
>> when the rebuild failed over night.
>
> Something in your system is untrustworthy.
>
>> But this morning, hdparm --read-sector is reading the "bad" sectors =
fine.
>
> What does smartctl say about your drives (all of them)?
>
>> I already tried replacing the drive and the replacement drive also
>> reported media errors during the rebuild, that's why I came to belie=
ve
>> I had a bad slot.
>>
>> Now I have non-repeatable media errors.
>>
>> fyi: I have the problem drive connected via eSata now, so it's a
>> different controller totally than where it was when the failure firs=
t
>> occurred.
>
> Are the errors in /var/log/messages only from that drive? =A0If so, t=
hen that
> drive is probably toast.
>
>> Any thoughts?
>
> Your prior e-mail said that you re-created the array. =A0I didn't see=
 that you
> had definitively nailed down the problem at that point, so it probabl=
y wasn't
> a good idea. =A0In particular, it destroys all prior metadata on the =
array
> members. =A0If you didn't keep the output of "mdadm -E" for each driv=
e, that
> information is now lost.
>
> In general, "--create" is a last resort, and only to be used for reco=
very
> when you have absolute confidence you understand the layout (mdadm -E
> printouts of the original array). =A0"--assemble --force" is the prop=
er step
> after "--assemble" fails.
>
> I would completely scrub the questionable drive with random data, run=
 a long
> smartctl test on it, and replace it if it reports any re-allocated se=
ctors at
> that point.
>
> I would also run long smartctl tests on the other drives, looking for=
 pending
> sectors or re-allocated sectors. =A0If any, I would plan on replaceme=
nts for
> them as well, and would try to validate the content of your files. =A0=
You do
> have a backup to compare against, after all.
>
> If you are running a Debian-based distro, and the array contains your=
 rootfs,
> you might find "debsums" useful.
>
> HTH,
>
> Phil



--=20
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
CNN/TruTV Aired Forensic Imaging Demo -
=A0=A0 http://insession.blogs.cnn.com/2010/03/23/how-computer-evidence-=
gets-retrieved/

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
