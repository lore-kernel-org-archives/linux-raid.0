From: maarten <maarten@ultratux.net>
Subject: Re: Spares and partitioning huge disks
Date: Sat, 8 Jan 2005 17:58:53 +0100
Message-ID: <200501081758.53583.maarten@ultratux.net>
References: <200501081633.j08GXK910004@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501081633.j08GXK910004@www.watkins-home.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday 08 January 2005 17:33, Guy wrote:

> You plan on using an 80 gig disk as a spare disk.  2 40 Gig partitions.  If
> both spares end up in the same RAID5 array, that would be bad!  mdadm
> supports spare groups, you should create 2 groups, put 1 spare partition in
> each group.  Then put 1/2 of your RAID5 arrays in each group.

Good point.  But I was planning to monitor it a bit, so I suppose I'd notice 
that, and add another disk to remedy it.  I just decommissioned 4 80GB drives 
so there's plenty where they came from. ;)

...
As it turns out I do indeed need to kill the LVM2 array and downgrade to lvm1 
yet again, because 2.4.28 seems to have no support for it.  Bummer.
That's isn't too bad, the raid arrays stay active so the long resyncs will not 
happen, just the incredibly slow tar-over-netcat network backup session.
Before I do this I must make sure that the old data disks are still okay...

Maarten

