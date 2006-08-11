From: "John Stoffel" <john@stoffel.org>
Subject: Re: Resize on dirty array?
Date: Fri, 11 Aug 2006 13:34:54 -0400
Message-ID: <17628.49086.180013.566163@stoffel.org>
References: <44D7DC93.2070905@net1plus.com>
	<17623.57067.835826.446152@cse.unsw.edu.au>
	<44D8E535.9080208@net1plus.com>
	<17625.24594.568139.430440@cse.unsw.edu.au>
	<44D9C6F5.7070501@net1plus.com>
	<68c491a60608090437l7e3b583el2214cbe6f01009ab@mail.gmail.com>
	<Pine.LNX.4.64.0608090846160.16324@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0608090846160.16324@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Mark" == Mark Hahn <hahn@physics.mcmaster.ca> writes:

>> RAID is no excuse for backups.

Mark> I wish people would quit saying this: not only is it not helpful,
Mark> but it's also wrong. 

You've got to be kidding, right?  A backup is another aspect of data
protection.  RAID is another form.  Both have their uses, and both
should be used on any system with important data.  

You're just spouting the wrong thing here and I really dislike seeing
it, which has prompted this reply.

Mark> a traditional backup is nothing more than a strangely async
Mark> raid1, with the same space inefficiency.  tape is not the
Mark> answer, and getting more not.  the idea of a periodic snapshot
Mark> to media which is located apart and not under the same load as
Mark> the primary copy is a good one, but not cheap or easy.  backups
Mark> are also often file-based, which is handy but orthogonal to
Mark> being raid (or incremental, for that matter).  and backups don't
Mark> mean you can avoid the cold calculation of how much reliability
Mark> you want to buy.  _that_ is how you should choose your storage
Mark> architecture...

You again mixing up your ideas here.  This is the first time I've
ever heard someone imply that backups to tape are a form of RAID,
never.  You really have an interesting point of view here.

Now maybe you do have some good points, but they're certainly not
articulated clearly.  

Just to work through them:

First, backups to tape may not be cheap or easy, especially with the
rise of 250gb disks for $100.  Buying a tape drive that has the space
and performance to backup that amount of data can be a big investment.

Second, reliability is a different measure from that of data
retention.  I can have the most reliable RAID system on a server which
can handle multiple devices failing (because they weren't reliable),
or power supply failure or connectivity failures, etc.  

But if a user deletes a file and it can't be recovered from your RAID
system, then how much help has that RAID system been?  Now you may
argue that reliability includes backups, but that's just wrong.
Reliability is a measure of the media/sub-system.  It's not a measure
of how good your backups are.

So you then claim that snapshots are a great way to get cheap and easy
backups, especially when you have reliable RAID.  So what happens when
your building burns down?  Or even just your house?  (As an aside,
while I do backups at home, I don't take them offsite in case of
fire.  Shame on me, and I'm a SysAdmin by profession!)  So how do you
know that your snapshots are reliable?  Are they filesystem based?
Are they volume based?  If volume based, how do you get the filesystem
in a quiescent state to make sure there's no corruption when you make
the snapshot?  It's not a trivial problem.  And even traditional
backups to tape have this issue.  

I'd write more, but I'm busy with other stuff and I wanted to hear
your justifications in more detail before I bothered spending the time
to refute them.

John
