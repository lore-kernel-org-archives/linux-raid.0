From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: Re: Disappointing performance of copy (MD raid + XFS)
Date: Thu, 10 Dec 2009 09:44:28 +0000
Message-ID: <73e903670912100144k2675754n2ef688a944364b42@mail.gmail.com>
References: <4B204334.1000605@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B204334.1000605@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: xfs@oss.sgi.com, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Dec 10, 2009 at 12:39 AM, Asdo <asdo@shiftmail.org> wrote:
> Hi all,
>
> I'm copying a bagzillion of files (14TB) from a 26disk MD-raid 6 array to a
> 16disk MD-raid 6 array.
> Filesystems are XFS for both arrays.
> Kernel is 2.6.31 ubuntu generic-14
> Performance is very disappointing, going from 150MB/sec to 22MB/sec
> depending apparently to the size of files it encounters. 150MB/sec is when
> files are 40-80MB in size, 22MB/sec is when files are 1MB in size on
> average, and I think I have seen around 10MB/sec when they are of 500KB
> (this transfer at 10MB/sec was in parallel with another faster one however).

This may not be related, but I have had some general problems
regarding transfer rates in Ubuntu. Using a vanilla kernel seemed to
help: http://kernel.ubuntu.com/~kernel-ppa/mainline/

-- Kristleifur
