From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID5 created by 8 disks works with xfs
Date: Mon, 02 Apr 2012 15:41:27 -0500
Message-ID: <4F7A0EF7.5010804@hardwarefreak.com>
References: <CACwgYDPQBNa7z7WcyUjV2Rx8Qf47r7eaRCowNKxjLBz+fYcfvQ@mail.gmail.com> <CADNH=7H_rgiY4fkB0SHo0yPhSBib7Gq-E_fu18yuJx=enn-eGg@mail.gmail.com> <4F776492.4070600@hardwarefreak.com> <CACwgYDOSrEYUps2VLpFSZ-irH7Mn_-BWrOYYDgXS=ULrmVuEPw@mail.gmail.com> <4F77D0B2.8000809@hardwarefreak.com> <CACwgYDMx6nQF-OwYj-BA+sZivUK=kmv2tPukgf5JGwA1vMTGrA@mail.gmail.com> <4F77EA55.6090004@hardwarefreak.com> <jl9ate$2me$1@dough.gmane.org> <4F784A06.1@anonymous.org.uk> <CA+res+QkLi7sxZrD-XOcbR47CeJ5gADf7P6pa1w1oMf8CKSB4g@mail.gmail.com> <4F795CE2.9050106@anonymous.org.uk> <CA+res+SSJ49cPubOdmXi6Z3jnE+4wzsh1MJehs78U82e3iDhaA@mail.gmail.com> <4F797F46.10600@anonymous.org.uk>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F797F46.10600@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Jack Wang <jack.wang.usish@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/2/2012 5:28 AM, John Robinson wrote:

> My fantasy configuration in your 16-drive chassis would be 2 6-drive
> RAID6s, striped together in RAID0, with an SSD cache over the top built
> from two SSDs in RAID10 (or if I was feeling really paranoid, 3 SSDs in
> RAID10,n3), with the remaining slot containing a hot spare for the RAID6s.

This advice is not sound.  The introductory "My fantasy" tends to put an
exclamation point on this fact.  This configuration is completely
unsuitable for the workload described.

I already described the most optimal configuration for this workload,
given the OP's current hardware, including all the commands to build it.
 The staged SSD idea has merit, as well as the SSD write cache idea.  If
going this route, two SLC SSDs should simply be mirrored.  Using 3 of
them or a RAID 1E variant on two of them is silly.

-- 
Stan
