From: Phil Turmel <philip@turmel.org>
Subject: Re: zeroed superblock on raid6
Date: Sat, 18 Feb 2012 14:26:41 -0500
Message-ID: <4F3FFB71.9090007@turmel.org>
References: <20120217153441.761b673b719bce80c9046cdc1b2220df.6d4c8e4316.mailapi@mailapi03.secureserver.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120217153441.761b673b719bce80c9046cdc1b2220df.6d4c8e4316.mailapi@mailapi03.secureserver.net>
Sender: linux-raid-owner@vger.kernel.org
To: dragos@mpigani.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Dragos,

On 02/17/2012 05:34 PM, dragos@mpigani.org wrote:
> Hi, Following a reboot my 9 drive raid6 array refused to assemble.
> Mdadm told me that some drives had a zero superblock.

This sounds strange.  I don't think mdadm has an error message that
says that.  It does have an error message saying that you might need
to perform --zero-superblock in a certain (dangerous) case.

> I use the controller on the motherboard and $20 4-port add-on cards.
> I tried to use some advice found on the net and zeroed all my drives
> superblocks..... What can I do to recover my non-backed-up data?

You got bad advice.  "--zero-superblock" discards the details of your
array setup, making it very difficult to figure out the correct
recovery details.  It may still be possible, but you've dramatically
reduced the odds of success.

> I will send you all the logs you need, if any. Just let me know which
> please.

In order of importance / usefulness:

1) any copies of "mdadm --detail /dev/mdX" and "mdadm --examine /dev/sdX"
you might have kept from *before* the crisis.

2) contents of boot-up "dmesg" or corresponding syslog from *before* the
crisis.

3) Contents of first failed boot-up dmesg.

4) Output of "lsdrv" script from http://github.com/pturmel/lsdrv

5) Details of all of the commands you attempted after the failed bootup,
in order.  Possibly from your shell history.

> Thank you very much for your help.

You're welcome.

Phil
