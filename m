From: Another Sillyname <anothersname@googlemail.com>
Subject: Re: Fwd: RAID6 Array crash during reshape.....now will not re-assemble.
Date: Fri, 4 Mar 2016 20:30:49 +0000
Message-ID: <CAOS+5GEZxF6B7f9W3eQg07fahYf02EGStu2whzWGTP4+p71fPQ@mail.gmail.com>
References: <CAOS+5GEd4E2wzYhw0rPdrZnjK6UwAUdKCQLLTxXrdPO8d7hS7w@mail.gmail.com>
	<56D6E883.50801@youngman.org.uk>
	<CAOS+5GHof=F94x58SKqFojV26hGpDSLF85dFfm8Xc6M43sN6jA@mail.gmail.com>
	<CAOS+5GEfQ2p0xguguKC3uXW8GYBDCxt2vk=-Ci6+nTKwkcWtdQ@mail.gmail.com>
	<CAOS+5GGX8QBo3=s+Mcj=Kd6VSmZyatfZ30NXBy8E=4WJE6z0sA@mail.gmail.com>
	<CAOS+5GGB5gVSFJbYwwJu+z0C0oyYPzsLRhnjD6FkmLEWFFquFA@mail.gmail.com>
	<56D8348E.9070802@youngman.org.uk>
	<CAOS+5GH1Rcu8zGk1dQ+aSNmVzjo=irH65KfPuq1ZGruzqX_=vg@mail.gmail.com>
	<CAOS+5GHUKD63M90zWfiv14QkJunj2QF+gYqDMrg208-S4oXE2Q@mail.gmail.com>
	<56D878E8.1060409@prgmr.com>
	<CAOS+5GEnvtPMUqorddDNUvkNr2+K2S=0N76i3f0AkAOE-7U4Pg@mail.gmail.com>
	<22232.41693.691818.451316@quad.stoffel.home>
	<CAOS+5GFfNdeYrfw6j_LowkW+g69h2fEOikHN1=-VQ98ZF9Jtpg@mail.gmail.com>
	<22232.48582.65930.822795@quad.stoffel.home>
	<CAOS+5GEeGapxE1_GUhxD6F2BCabso-M=h-HQYjZ0hvNxh04Hug@mail.gmail.com>
	<CAB-428mE21BZSvNCjyygQ4AWvRfRTyu7ZFfYZ8RYnEtbw+cMew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB-428mE21BZSvNCjyygQ4AWvRfRTyu7ZFfYZ8RYnEtbw+cMew@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alireza Haghdoost <alireza@cs.umn.edu>
Cc: John Stoffel <john@stoffel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

That's possibly true, however there are lessons to be learnt here even
if my array is not recoverable.

I don't know the process order of doing a reshape....but I would
suspect it's something along the lines of.

Examine existing array.
Confirm command can be run against existing array configuration (i.e.
It's a valid command for this array setup).
Do backup file (if specified)
Set reshape flag high
Start reshape

I would suggest....

There needs to be another step in the process

Before 'Set reshape flag high' that the backup file needs to be
checked for consistency.

My backup file appears to be just full of EOLs (now for all I know the
backup file actually gets 'created' during the process and therefore
starts out as EOLs).  But once the flag is set high you are then
committing the array before you know if the backup is good.

Also

The drives in this array had been working correctly for 6 months and
undergone a number of reboots.

If, as we are theorising, there was some metadata from a previous
array setup on two of the drives that as a result of the reshape
somehow became the 'valid' metadata regarding those two drives RAID
status then I would suggest that during any mdadm raid create process
there is an extensive and thorough check of any drives being used to
identify and remove any possible previously existing RAID metadata
information...thus making the drives 'clean'.






On 4 March 2016 at 19:11, Alireza Haghdoost <alireza@cs.umn.edu> wrote:
> On Fri, Mar 4, 2016 at 1:01 PM, Another Sillyname
> <anothersname@googlemail.com> wrote:
>>
>>
>> Thanks for the suggestion but I'm still stuck and there is no bug
>> tracker on the mdadm git website so I have to wait here.
>>
>> Ho Huum
>>
>>
>
> Looks like it is going to be a long wait. I think you are waiting to
> do something that might not be inplace/available at all. That thing is
> the capability to reset reshape flag when the array metadata is not
> consistent. You had an old array in two of these drives and it seems
> mdadm confused when it observes the drives metadata are not
> consistent.
>
> Hope someone chip in some tricks to do so without a need to develop
> such a functionality in mdadm.
