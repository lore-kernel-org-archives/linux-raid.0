From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Changing Drive letters
Date: Sun, 13 Apr 2003 07:19:05 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16024.33481.82813.561607@notabene.cse.unsw.edu.au>
References: <Pine.LNX.4.44.0304101555440.25209-100000@karma.hagopian.net>
	<00ac01c2ffb5$4fff2580$6a01a8c0@wa1hco>
	<00c801c3007f$d03fbaf0$6a01a8c0@wa1hco>
	<16023.21137.893717.233525@notabene.cse.unsw.edu.au>
	<00d901c30095$9f8e8330$6a01a8c0@wa1hco>
	<3E97738F.7040500@hum.auc.dk>
	<16023.31242.311683.718259@notabene.cse.unsw.edu.au>
	<Pine.LNX.4.53.0304121504480.15759@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mr. James W. Laferriere on Saturday April 12
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: Mads Peter Bach <mpb@hum.auc.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday April 12, babydr@baby-dragons.com wrote:
> 	Hello Neil ,
> 
> On Sat, 12 Apr 2003, Neil Brown wrote:
> > On Saturday April 12, mpb@hum.auc.dk wrote:
> > > jeff millar wrote:
> ...snip...
> > > And then do
> > > mdadm --assemble /dev/md0 --uuid 49d38e1a:3ae5b824:9220fe3b:5a8129f0
> >
> > You don't need the uuid twice.  Given the above mdadm.conf,
> >
> >   mdadm --assemble /dev/md0 --scan
> > will work.
> 	With a known uuid for a previously created md device why must I
> 	re-do the device names ?  Please be elaborate .  Tia ,  JimL

Sorry, but I don't understand the question.  Who is redoing what
device names?

NeilBrown
