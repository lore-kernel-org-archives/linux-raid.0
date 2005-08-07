From: David Greaves <david@dgreaves.com>
Subject: Re: How to force a spare drive to take over in a RAID5?
Date: Sun, 07 Aug 2005 12:29:52 +0100
Message-ID: <42F5F0B0.3050105@dgreaves.com>
References: <45138.213.188.237.106.1123086677.squirrel@localhost><20050804195853.0866ade9.akpm@osdl.org><34082.213.188.237.106.1123228569.squirrel@localhost> <20050805010236.12d811ff.akpm@osdl.org> <006301c599ca$69410700$ab0e10ac@pinchy>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <006301c599ca$69410700$ab0e10ac@pinchy>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Cuss <mcuss@cdlsystems.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mark Cuss wrote:

> Hi!
>
> I have a 4 drive SW RAID5 running on my machine.  One of the drives is
> upset for some reason - I'm not sure if the drive itself is bad, but
> that's not too important right now.  The important thing is to get the
> RAID5 to stop using this drive and start using a spare drive that I
> just added.


> I did a raidhotadd to add in a new drive, sds.  Now, I would like the
> array to stop using sdr and reconstruct all of the parity tables on
> sds so I can pull sdr and get it replaced or whatever...
>
> Any ideas?

Install and read the manpage for mdadm

What kernel version?

David
