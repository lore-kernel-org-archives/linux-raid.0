From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm 2.6, linux 2.6.17, failed grow/reshape
Date: Wed, 21 Feb 2007 06:52:03 +1100
Message-ID: <17883.20835.24504.15249@notabene.brown>
References: <6264d2ec0702201047s7e732a2eq6b72f54af3f4ae4d@mail.gmail.com>
	<17883.18091.699835.980907@notabene.brown>
	<6264d2ec0702201122l2f718694k52ebbb1e9bd5717c@mail.gmail.com>
	<6264d2ec0702201123l1b0ca58boe51fff8946c4ba0a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Thomas Lang.s on Tuesday February 20
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Thomas_Lang=E5s?= <thomas.langaas@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday February 20, thomas.langaas@gmail.com wrote:
> On 2/20/07, Neil Brown <neilb@suse.de> wrote:
> > > It says that the device (md0) is in delta 4->5, but I'm unable to get
> > > it to restart reshaping.  Are all the data I had on the raid-device
> > > lost?  Or is it possible to make it restart where it left off?  It
> > > clearly knows how far it has come along, since I get some stats about
> > > that.
> > Hmm... it should "just work", and it my testing it does.
> 
> What should "kick off" the rebuild/reshape-process once it has been
> interrupted?

When the array is started, it notices the reshape is incomplete and
kick-starts the reshape.

> 
> > The reshape process regularly checkpoints its progress so it knows
> > where to start off from, and when you assemble the array again, it
> > should restart the reshape.
> 
> Ok, no matter if it's a different system assembling the drives?  The
> kernel is not running the md-device (if there is one?) from
> mdadm-2.6-source, it's running the one inside 2.6.17.

No, it doesn't matter if it is a different system, as long as the
kernel is new enough to understand reshaping (and i think 2.6.17 is
the earliest that understands it properly).

> 
> > Can you post kernel log messages showing md0 being assembled?  Also
> > the output of "mdadm -E" on a couple of drives might be helpful.
> 
> Running assemble:
> # ./mdadm --assemble --scan
> mdadm: failed to RUN_ARRAY /dev/.static/dev/md0: Invalid argument
> 
> Ouput from syslog:
> Feb 20 20:20:09 ubuntu kernel: [17197083.928000] md: md0 stopped.
> Feb 20 20:20:09 ubuntu kernel: [17197084.012000] md: bind<sdd1>
> Feb 20 20:20:09 ubuntu kernel: [17197084.012000] md: bind<sde1>
> Feb 20 20:20:09 ubuntu kernel: [17197084.012000] md: bind<sdf1>
> Feb 20 20:20:09 ubuntu kernel: [17197084.012000] md: bind<sdg1>
> Feb 20 20:20:09 ubuntu kernel: [17197084.016000] md: bind<sdc1>

Is that all....
Could it be that the kernel you are now using was not compiled with
  CONFIG_MD_RAID5_RESHAPE=y
that would explain an error with no message.  In fact it is the only
thing that would explain the messages you got.  So please try with a
kernel that has RAID5_RESHAPE enabled.

Thanks,
NeilBrown
