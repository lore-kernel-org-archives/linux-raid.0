From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Wed, 5 Jan 2005 10:09:30 -0500
Message-ID: <200501051509.j05F9a925718@www.watkins-home.com>
References: <41DBB6C6.2040301@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41DBB6C6.2040301@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: 'Brad Campbell' <brad@wasp.net.au>, 'RAID Linux' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Dude!  That's a lot of mp3 files!  :)

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Brad Campbell
Sent: Wednesday, January 05, 2005 4:44 AM
To: RAID Linux
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10
crashing repeatedly and hard)

Sorry, sent this privately by mistake.

Peter T. Breuer wrote:

> If you do an md5sum on file contents and compare with a previous md5sum
> run, then it will be detected provided that the error occurs in a file,
> but assuming that your disk is 50% full, that is only 50% likely.
> 
> I.e. "it depends on your test".

brad@srv:~$ df -h | grep md0
/dev/md0              2.1T  2.1T  9.2G 100% /raid

I'd say likely :p)

Regards,
Brad

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

