From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Multiple disk failure - recover?
Date: Thu, 11 Jul 2002 00:30:53 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15660.17693.461131.39650@notabene.cse.unsw.edu.au>
References: <15660.15549.501687.976304@notabene.cse.unsw.edu.au>
	<Pine.LNX.4.30.0207101604520.25329-300000@duplo.agenda.si>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Danilo Godec on Wednesday July 10
To: Danilo Godec <danci@agenda.si>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday July 10, danci@agenda.si wrote:
> OK, it's all attached. One file contains results of mdadm --examine, the
> other is what I get on the screen with mdadm --assemble (w/wo
--run)...

Hmmm.  Yes --force isn't doing all that it should do. I'll have to
look into that.

You should be able to use create successfully.

If the original order was b2,c2,a2, which is what the --examine
suggests, and you want to not use b2, then

 mdadm --create /dev/md1 -l5 -c32 -n3 missing /dev/sdc2 /dev/sda2

should work.  It will not start a rebuild so you can mount it
read-only and if something was wrong, you can "mdadm --stop" and try
again with a different arrangement of drives.

If b2 and c2 are really the most recent, as it appears, then you might
want to use those:

  mdadm --create /dev/md1 -l5 -c32 -n3 /dev/sdb2 /dev/sdc2 missing

Again, this wont do a resync and as long as you don't touch the bad
block on b2, you should be able to access data.

NeilBrown
