From: Neil Brown <neilb@suse.de>
Subject: Re: Why "mdadm --monitor --program" sometimes only gives 2 command-line
 arguments to the program?
Date: Tue, 8 Jan 2008 14:52:03 +1100
Message-ID: <18306.62307.697601.949274@notabene.brown>
References: <14642331.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Hxsrmeng on Saturday January 5
Sender: linux-raid-owner@vger.kernel.org
To: Hxsrmeng <hxsrmeng@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday January 5, hxsrmeng@gmail.com wrote:
> 
> Hi all,
> 
> I need to monitor my RAID and if it fails, I'd like to call my-script to
> deal with the failure.
> 
> I did: 
> mdadm --monitor --program my-script --delay 60 /dev/md1
> 
> And then, I simulate a failure with
> mdadm --manage --set-faulty /dev/md1 /dev/sda2
> mdadm /dev/md1 --remove /dev/sda2
> 
> I hope the mdadm monitor function can pass all three command-line
> arguments to my-script, including the name of the event, the name of the
> md device and the name of a related device if relevant.
> 
> But my-script doesn't get the third one, which should be /dev/sda2. Is
> this not "relevant"?
> 
> If I really need to know it's /dev/sda2 that fails, what can I do?

What version of mdadm are you using?
I'm guessing 2.6, 2.6.1, or 2.6.2.
There was a bug introduced in 2.6 that was fixed in 2.6.3 that would
have this effect.

NeilBrown
