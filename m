From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: inserting a new disk in a raid 1
Date: Fri, 14 Jun 2002 19:56:20 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15625.48580.739590.745519@notabene.cse.unsw.edu.au>
References: <1024044540.2246.12.camel@Asterix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from =?ISO-8859-1?Q?Lo=EFc?= Paillotin on  June 14
To: =?ISO-8859-1?Q?Lo=EFc?= Paillotin <loic.paillotin@qualimucho.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> Hello there.
> 
> I recently set  up a linux system. I had only one hard drive by that
> time, so I tought that I would configure it for software raid and see
> later when I had my second drive.
> I now have my second drive, and I don't have a clue on how to include i=
> t
> in my raid array. I tried to follow the tutorials ( that is, the raid
> HOWTO, but I'm probalby missing someting......
> thank you in advance,

Does
  raidhotadd /dev/md0 /dev/hdc1

work, where you replace /dev/hdc1 with the name of the partition on
your new drive.
If not, more details are needed, at the very least:

  cat /proc/partitions
  cat /proc/mdstat

NeilBrown
