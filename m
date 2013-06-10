From: Ramon Hofer <ramonhofer@bluewin.ch>
Subject: Re: Enlarging device of linear array
Date: Mon, 10 Jun 2013 18:58:39 +0200
Message-ID: <20130610185839.7fa66b44@hoferr-desktop.hofer.rummelring>
References: <20130608201810.26c19641@hoferr-x61s.hofer.rummelring>
	<51B43D70.50004@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51B43D70.50004@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 09 Jun 2013 03:31:44 -0500
Stan Hoeppner <stan@hardwarefreak.com> wrote:

> On 6/8/2013 1:18 PM, Ramon Hofer wrote:
<snip>
> > If in some years one of the oldest 1.5 TB disks of md2 or any other
> > fails, I could replace it with a bigger one and at the same time the
> > other disks of the same device as well and get additional space?
> 
> You can use the extra capacity, but not in the way you're considering.
> This is due to the characteristics of a linear array.
> 
> You have been using raw disks, not partitions.  So when you replace a
> dead drive you will need to create a partition on the replacement that
> is the same size or a few sectors larger than the disk being replaced.
> You will then use this partition as the replacement device in the
> array rebuild.  After you have replaced all 4 drives in this manner,
> you will create a 2nd partition in the free space on each.  You will
> then create another RAID5 array from these 4 partitions and add it
> just as you did the other RAID5s.

Ha, I didn't think about that.
That's easy :-)


Thanks alot
Ramon
