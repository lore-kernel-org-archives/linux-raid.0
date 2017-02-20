From: Phil Turmel <philip@turmel.org>
Subject: Re: assistance recovering failed raid6 array
Date: Mon, 20 Feb 2017 10:39:16 -0500
Message-ID: <e01061cb-ea4c-4f64-16e8-e6027adbc70d@turmel.org>
References: <58AA4B1E.1030809@bosner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <58AA4B1E.1030809@bosner.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Bosner <martin@bosner.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/19/2017 08:49 PM, Martin Bosner wrote:
> I am running a software raid6 with 36 x 3TB disks (sda to sdaj). All
> disks have one partition (gpt, 100%, primary, raid on) and i am using
> btrfs on top of the raid.
> 
> Last week one of the disks failed and was unrecoverable. I replaced the
> disk (sdk) with a new one and the resync process started.
> At around 80% recovery two further disks failed and the recovery process
> was stopped. That failed disks are sdm and sdh.
> 
> All other disks seem to be fine and I was about the use the "mdadm
> --create" command when i remembered the lines
> "You have been warned! It's better to send an email to the linux-raid
> mailing list with detailed information"
> 
> So here i am for an advice how to continue.

More information, please.  Paste inline, untrimmed, in your reply with
line wrapping disabled.  Plain text only.  Use multiple mails if needed.
List limit is ~100k IIRC.

# dmesg

# for x in /dev/sd[a-z] /dev/sda[a-j] ; do echo mdadm -E ${x}1 ; smartctl -iA -l scterc $x ; done

Phil
