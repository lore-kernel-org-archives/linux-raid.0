From: Brad Campbell <brad@fnarfbargle.com>
Subject: Re: mdadm raid1 read performance
Date: Thu, 05 May 2011 07:36:13 +0800
Message-ID: <4DC1E2ED.6070201@fnarfbargle.com>
References: <BANLkTim8Ehn0fANtibg7X1cMVvOgt7CNMA@mail.gmail.com>	<20110504105822.21e23bc3@notabene.brown>	<BANLkTimzqu1C+_Z2t5m1bjduXFeRwbgssQ@mail.gmail.com>	<4DC0F2B6.9050708@fnarfbargle.com>	<BANLkTinbFZf=kV=3eUe2S6XNAOst_McX4w@mail.gmail.com> <BANLkTikQTKPuY+Mg8h9ZOkJPoEQ-jGTeLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTikQTKPuY+Mg8h9ZOkJPoEQ-jGTeLg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Liam Kurmos <quantum.leaf@gmail.com>
Cc: Roberto Spadim <roberto@spadim.com.br>, Brad Campbell <lists2009@fnarfbargle.com>, Drew <drew.kay@gmail.com>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/05/11 07:08, Liam Kurmos wrote:
> Thanks to all who replied on this.
>
> I somewhat naively assumed that having 2 disks with the same data
> would mean a similar read speed to raid0 should be the norm (and i
> think this is a very popular miss-conception).
> I was neglecting the seek time to skip alternate blocks which i guess
> must the flaw.
>
> In theory though if i was reading a larger file, couldn't one disk
> start reading at the beginning to a buffer and one start reading from
> half way ( assuming 2 disks) and hence get close to 2x single disk
> speed?
>
> as a separate question, what should be the theoretical performance of raid5?
>
> in my tests i read 1GB and throw away the data.
> dd if=/dev/md0 of=/dev/null bs=1M count=1000
>
> With 4 fairly fast hdd's i get
>
> raid0: ~540MB/s
> raid10: 220MB/s
> raid5: ~165MB/s
> raid1: ~140MB/s  (single disk speed)
>
> for 4 disks raid0 seems like suicide, but for my system drive the
> speed advantage is so great im tempted to try it anyway and try and
> use rsync to keep constant back up.
>

Try RAID10 with the far layout. It should give you streaming reads the same as RAID0

Brad
