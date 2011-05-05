From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: mdadm raid1 read performance
Date: Thu, 5 May 2011 13:10:06 +0200
Message-ID: <20110505111006.GB11441@www2.open-std.org>
References: <BANLkTim8Ehn0fANtibg7X1cMVvOgt7CNMA@mail.gmail.com> <20110504105822.21e23bc3@notabene.brown> <BANLkTimzqu1C+_Z2t5m1bjduXFeRwbgssQ@mail.gmail.com> <4DC0F2B6.9050708@fnarfbargle.com> <BANLkTinbFZf=kV=3eUe2S6XNAOst_McX4w@mail.gmail.com> <BANLkTikQTKPuY+Mg8h9ZOkJPoEQ-jGTeLg@mail.gmail.com> <20110505094538.0cef02cc@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110505094538.0cef02cc@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Liam Kurmos <quantum.leaf@gmail.com>, Roberto Spadim <roberto@spadim.com.br>, Brad Campbell <lists2009@fnarfbargle.com>, Drew <drew.kay@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, May 05, 2011 at 09:45:38AM +1000, NeilBrown wrote:
> On Thu, 5 May 2011 00:08:59 +0100 Liam Kurmos <quantum.leaf@gmail.com> wrote:
> 
> > as a separate question, what should be the theoretical performance of raid5?
> 
> x(N-1)
> 
> So a 4 drive RAID5 should read at 3 time the speed of a single drive.

Actually, theoretically, it should be more than that for reading, more like N minus
some overhead. In a raid5 stripe of 4 disks, when reading you do not read
the checksum block, and thus you should be able to have all 4 drives
occupied with reading real data. Some benchmarks back this up, 
http://home.comcast.net/~jpiszcz/20080329-raid/
http://blog.jamponi.net/2008/07/raid56-and-10-benchmarks-on-26255_10.html
The latter reports a 3.44 times performance for raid5 reads with 4
disks, significantly over the N-1 = 3.0 mark.

For writing, you are correct with the N-1 formular.

best regards
keld
