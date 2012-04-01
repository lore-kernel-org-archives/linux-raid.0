From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: RAID5 created by 8 disks works with xfs
Date: Sun, 01 Apr 2012 13:28:54 +0100
Message-ID: <4F784A06.1@anonymous.org.uk>
References: <CACwgYDPQBNa7z7WcyUjV2Rx8Qf47r7eaRCowNKxjLBz+fYcfvQ@mail.gmail.com> <CADNH=7H_rgiY4fkB0SHo0yPhSBib7Gq-E_fu18yuJx=enn-eGg@mail.gmail.com> <4F776492.4070600@hardwarefreak.com> <CACwgYDOSrEYUps2VLpFSZ-irH7Mn_-BWrOYYDgXS=ULrmVuEPw@mail.gmail.com> <4F77D0B2.8000809@hardwarefreak.com> <CACwgYDMx6nQF-OwYj-BA+sZivUK=kmv2tPukgf5JGwA1vMTGrA@mail.gmail.com> <4F77EA55.6090004@hardwarefreak.com> <jl9ate$2me$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <jl9ate$2me$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/04/2012 11:33, David Brown wrote:
[...]
> For an application like this, it would probably make sense to put the
> xfs log (and the mdraid bitmap file, if you are using one) on a separate
> disk - perhaps a small SSD.

Now that you've suggested that, it occurs to me that for an application 
like this, the OP might be better doing his multiple slow streams to a 
spool folder on SSD, and copying over to the big array of spinning rust 
when each stream completes. 200 streams of 500MB is 100GB of data, so a 
pair of slightly larger SSDs in RAID1 (or RAID10, to balance the reads 
coming off) would do nicely as a spool area.

This might also be a good application for bcache, FlashCache or whatever.

Cheers,

John.

