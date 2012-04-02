From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID5 created by 8 disks works with xfs
Date: Mon, 02 Apr 2012 00:43:10 -0500
Message-ID: <4F793C6E.1080000@hardwarefreak.com>
References: <CACwgYDPQBNa7z7WcyUjV2Rx8Qf47r7eaRCowNKxjLBz+fYcfvQ@mail.gmail.com> <CADNH=7H_rgiY4fkB0SHo0yPhSBib7Gq-E_fu18yuJx=enn-eGg@mail.gmail.com> <4F776492.4070600@hardwarefreak.com> <CACwgYDOSrEYUps2VLpFSZ-irH7Mn_-BWrOYYDgXS=ULrmVuEPw@mail.gmail.com> <4F77D0B2.8000809@hardwarefreak.com> <CACwgYDMx6nQF-OwYj-BA+sZivUK=kmv2tPukgf5JGwA1vMTGrA@mail.gmail.com> <4F77EA55.6090004@hardwarefreak.com> <jl9ate$2me$1@dough.gmane.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <jl9ate$2me$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/1/2012 5:33 AM, David Brown wrote:

> For an application like this, it would probably make sense to put the
> xfs log (and the mdraid bitmap file, if you are using one) on a separate
> disk - perhaps a small SSD.

XFS only journals metadata changes.  Thus an external journal is not
needed here as there is no metadata in the workload.

-- 
Stan
