From: David Greaves <david@dgreaves.com>
Subject: Re: zero-superblock, Re: some ?? re failed disk and resyncing of
 array
Date: Tue, 03 Feb 2009 08:48:47 +0000
Message-ID: <498804EF.6070102@dgreaves.com>
References: <1233389816.28363.1297740563@webmail.messagingengine.com> <49842A1E.1090105@dgreaves.com> <1233403388.29916.1297756217@webmail.messagingengine.com> <4985FAF1.2090208@tmr.com> <1233622333.26974.1298163227@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1233622333.26974.1298163227@webmail.messagingengine.com>
Sender: linux-raid-owner@vger.kernel.org
To: whollygoat@letterboxes.org
Cc: linux-raid@vger.kernel.org, Bill Davidsen <davidsen@tmr.com>
List-Id: linux-raid.ids

whollygoat@letterboxes.org wrote:
> Can anyone provide any more insight with the below?
I agree the error messages don't help :)
Old version of mdadm? IIRC the error reports are better now.

> fly:~# mdadm --zero-superblock /dev/hdk1
> mdadm: Unrecognised md component device - /dev/hdk1
It is likely that hdk1 is not an md component device and has no superblock.

> fly:~# mdadm -a /dev/hdk1
> mdadm: /dev/hdk1 does not appear to be an md device
Normally:
  mdadm [mode] <raiddevice> [options] <component-devices>
so:
  mdadm /dev/md0 -a /dev/hdk1
would work (otherwise which raid are you adding to?)


David


-- 
"Don't worry, you'll be fine; I saw it work in a cartoon once..."
