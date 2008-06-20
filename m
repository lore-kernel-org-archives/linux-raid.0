From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: External bitmap disappears
Date: Fri, 20 Jun 2008 08:48:14 -0500
Message-ID: <cccedfc60806200648o39b2157cma2b88426abeee466@mail.gmail.com>
References: <cccedfc60806200617k37498d4y1f01072145271d00@mail.gmail.com>
	 <485BB47E.8030804@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <485BB47E.8030804@msgid.tls.msk.ru>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'd like to offer a suggestion, then:

perhaps mdadm --detail --scan
could add bitmap= to it's output as appropriate?


On Fri, Jun 20, 2008 at 8:45 AM, Michael Tokarev <mjt@tls.msk.ru> wrote:
> Jon Nelson wrote:
>> I've configured a raid10,f2 with an external bitmap:
>>
>> mdadm --grow --bitmap=/md0.bitmap /dev/md0
>>
>> The root ('/') filesystem is NOT on the raid. It's a normal partition
>> (/dev/sdb1, the boot device actually).
>> After reboot, cat /proc/mdstat does not show a bitmap. What's up with
>> that? That sure doesn't seem right.
>
> If a bitmap isn't stored inside a superblock, you have to
> specify the same filename when ASSEMBLING the array.
>
> Add it to mdadm.conf file.
>
> /mjt
>
>



-- 
Jon
