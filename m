From: hpa@zytor.com (H. Peter Anvin)
Subject: Re: [PATCH md 2 of 4] Fix raid6 problem
Date: Thu, 3 Feb 2005 02:12:38 +0000 (UTC)
Message-ID: <cts1am$6c8$1@terminus.zytor.com>
References: <38038.212.158.231.74.1099526180.squirrel@mail.fsck.co.uk> <200412090021.iB90L4MK014200@terminus.zytor.com> <33023.212.158.231.74.1106488921.squirrel@mail.fsck.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Followup to:  <33023.212.158.231.74.1106488921.squirrel@mail.fsck.co.uk>
By author:    "A. James Lewis" <james@fsck.co.uk>
In newsgroup: linux.dev.raid
>
> 
> Sorry for the delay in replying, I've been using RAID6 in a real life
> situation with 2.6.9 + patch, for 2 months now, with 1.15Tb of storage,
> and I have had more than 1 drive failure... as well as some rather
> embarasing hardware corruption which I traced to a faulty IDE controller.
> 
> Dispite some random DMA corrupion, and loosing a total of 3 disks, I have
> not had any problems with it RAID6 itself, and really it has litereally
> saved my data from being lost.
> 
> I ran a diff against the 2.6.9 patch and what is in 2.6.10... and they are
> not the same, presumably a more elegant fix has been implimented for the
> production kernel??
> 

I think there are some other (generic) fixes in there too.

Anyway... I'm thinking of sending in a patch to take out the
"experimental" status of RAID-6.  I have been running a 1 TB
production server in 1-disk degraded mode for about a month now
without incident.

	-hpa

