From: David Rea <dave@daverea.com>
Subject: Re: RAID-5 spare drive: Can't make spare persist across reboot
Date: Sat, 30 May 2009 18:26:22 -0400
Message-ID: <984c80610905301526h6a71b79cyd1cb66c992db355a@mail.gmail.com>
References: <984c80610905301137l7649391fg64a8108769abd216@mail.gmail.com>
	 <18977.43758.674932.381022@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18977.43758.674932.381022@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, May 30, 2009 at 5:53 PM, Neil Brown <neilb@suse.de> wrote:

>> However, after a reboot, I'm back to 3 active and 0 spare drives. [s=
nip]
>
> This should "just work". =A0There might be some hints in
> /var/log/messages if you'd like to post that.

Here is the output of `cat /var/log/messages | grep raid`:
http://pastebin.ca/1441575

It seems that raid5 only sees the sd[acd] as active drives, but
doesn't pick up the spare.

>> -- Is there any way to instantiate a superblock on /dev/sdb1 so that
>> it can be associated with this array's UUID?
>
> You have already done that. =A0Use
> =A0 mdadm --examine /dev/sdb
> to confirm.

This successfully identifies /dev/sdb1 as a spare: http://pastebin.ca/1=
441576
However running `mdadm --examine /dev/sda` for example does not:
http://pastebin.ca/1441578
And running `mdadm --detail /dev/md0` also says no spares:
http://pastebin.ca/1441579

(let me know if you'd rather I paste these inline, for archival
purposes or what have you)

>> -- I have the ARRAY line (in mdadm.conf) specified by UUID; could th=
is
>> be causing the spare to be excluded, since it (presumably) does not
>> have a superblock?
>
> No. =A0And it does have a superblock.

Gotcha, I stand corrected! I guess at this point I just need to figure
out how to get the spare to recognize on bootup, since it's already
got the same UUID and is listed in mdadm.conf:
http://pastebin.ca/1441588

Thanks again for your help,
Dave
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
