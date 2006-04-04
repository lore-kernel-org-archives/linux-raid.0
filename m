From: David Greaves <david@dgreaves.com>
Subject: Re: Help needed - RAID5 recovery from Power-fail
Date: Tue, 04 Apr 2006 07:30:23 +0100
Message-ID: <4432127F.9040805@dgreaves.com>
References: <4431B2B3.9080700@nigelterry.net> <17457.46503.897583.343329@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17457.46503.897583.343329@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: "Nigel J. Terry" <nigel@nigelterry.net>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:

>On Monday April 3, nigel@nigelterry.net wrote:
>  
>
>>I wonder if you could help a Raid Newbie with a problem
>>    
>>
<snip>

>It looks like you lost a drive a while ago. Did you notice?
>
This is not unusual - raid just keeps on going if a disk fails.
When things are working again you really should read up on "mdadm -F" -
it runs as a daemon and sends you mail if any raid events occur.

See if FC4 has a script that automatically runs it - you may need to
tweak some config parameters somewhere (I use Debian so I'm not much help).

David

