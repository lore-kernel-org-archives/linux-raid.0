From: David Greaves <david@dgreaves.com>
Subject: Re: Help to decipher kernel io error log
Date: Thu, 28 Aug 2008 16:38:12 +0100
Message-ID: <48B6C664.6010108@dgreaves.com>
References: <48B677DB.4010306@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48B677DB.4010306@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter Rabbitson wrote:
> Greetings,
> 
> This is not a strictly raid question, but this is the best list I know
> of for this type of questions. Two days ago my server ground to a halt
> without apparent reasons. There were tons of processes in D state, with
> no signs of any significant work being done. I attributed it to resource
> starvation (the server is pretty loaded), rebooted and went on with my
> life.
> 
> Yesterday I received the log messages included at the bottom of this
> email. Since I am running a --level=10 --raid-devices=4 --layout=f3 I am
> not that worried abiut losing data, and decided to investigate. I
> removed (mdadm -r) the devices in question from the arrays, power cycled
>  the server, and executed a full badblocks -svw /dev/sda run. It passed
> with flying colors.
> 
> So here is my question - what does the log below signify (there are no
> omissions, this is all I got) - is my controller dying? Or is there
> indeed a well masked hard drive failure? Should I change the drive, the
> controller, or both?

Looks to me like a drive failed with a sector problem.
Then, quite possibly the sector was re-allocated.
What does
 smartctl -a /dev/sda
say?

Run
  man smartctl
to ensure you're informed :)
Then run:
  smartctl -t long /dev/sda
(you may need smartctl -o on /dev/sda)

Depending on the version of smartctl you'll be given a 'poll time' or completion
time. It's safe to run
 smartctl -a /dev/sda
early, but make sure the selftest has completed and post the output of that -
especially noting any differences to the earlier -a.

David

