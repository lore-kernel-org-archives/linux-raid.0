From: David Greaves <david@dgreaves.com>
Subject: Re: modifying a running array
Date: Mon, 15 Nov 2004 15:19:06 +0000
Message-ID: <4198C8EA.1070000@dgreaves.com>
References: <1100522100.31575.12.camel@xstar>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1100522100.31575.12.camel@xstar>
Sender: linux-raid-owner@vger.kernel.org
To: Lieven Van Acker <lieven.vanacker@ugent.be>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lieven Van Acker wrote:

>Hey folks,
>
>I didn't find any direct pointers on this issue, so maybe you experts
>can advice me...
>
>I was setting up a system, had only one disk at setup time but wanted to
>configure raid 1 in advance...
>
>so I used 
>
>mdadm --create /dev/md0 --force --run --level=1 --raid-devices=1
>/dev/sda1
>  
>
On your new disk try this:
mdadm --create /dev/md1 --level=1 --raid-devices=2 /dev/sdb1 missing

Then make a filesystem on it and copy over the data from /dev/md0
then stop /dev/md0

Once you've done all that try:

mdadm /dev/md1 -a /dev/sda1

I think that'll get you where you want to be.

you may want to hang back a while in case I made a typo ;)

David


PS from the manpage:
Setting a value of 1 is probably a mistake  and so requires that --force 
be specified first.
Guess what ;)
