From: "Grant Grundler" <grundler@google.com>
Subject: Re: data corruption: ext3/lvm2/md/mptsas/vitesse/seagate
Date: Sat, 8 Mar 2008 13:23:18 -0800
Message-ID: <da824cf30803081323i2911567eu4a03d7167964d92d@mail.gmail.com>
References: <200803062108.m26L8e4i020882@colby.verdasys.com>
	 <1204843956.2673.8.camel@vema.umeoce.maine.edu>
	 <200803072239.m27MdGVv028621@colby.verdasys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200803072239.m27MdGVv028621@colby.verdasys.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
To: Marc Bejarano <beej@alum.mit.edu>
Cc: Steve Cousins <steve.cousins@maine.edu>, linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Mar 7, 2008 at 2:39 PM, Marc Bejarano <beej@alum.mit.edu> wrote:
> At 17:52 3/6/2008, Steve Cousins wrote:
>   >Have you run any memory tests on the machine?
>
>  no, but my suspicions lay elsewhere.  could bad memory explain the
>  right bits ending up in the wrong place on only one half of a mirror?

IMHO, not likely unless the page is getting copied before being DMA'd
but the HBA. DMA is a form of copying but would have a different
"signature" than bad memory (cacheline vs sub-cacheline corruption).

If you know that the two RAID mirrors are different, can you compare
them block-by-block?

First step to solving any data corruption issue is characterizing
the corruption: length of wrong data, alignment of wrong data,
and if possible, determine if wrong data is "stale" or where it
originates. jejb already suggested this.

If you can destroy (and later restore) the data on one or more
of the disks, you might consider running disktest from:
   http://test.kernel.org/autotest/

I've parked an SVN snapshot on:
   http://iou.parisc-linux.org/~grundler/autotest-20080307.tgz

See autotest/tests/disktest/ . IIRC this test will tag each 512 byte
"sector" it writes to a file and will read back those tags later to
verify the sectors made it to media.

hth,
grant
