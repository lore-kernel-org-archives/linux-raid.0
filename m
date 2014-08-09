From: Killian De Volder <killian.de.volder@megasoft.be>
Subject: Re: Mdadm misuse or bug ? mdadm: Cannot find 8:18: No such file or
 directory
Date: Sat, 09 Aug 2014 10:32:54 +0200
Message-ID: <53E5DCB6.4010809@megasoft.be>
References: <53E54AC5.4010904@megasoft.be>	<20140809104915.05b8da17@notabene.brown>	<53E5D329.4040004@megasoft.be> <20140809182316.0c16ac48@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140809182316.0c16ac48@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

sdb2 worked ! (And sorry for not trying sdb2, mdadm asks for /dev/md? so you naturally write /dev/sd? for the disk thereafter too :) )
Now the question should -r failed work ?

Killian De Volder

On 09-08-14 10:23, NeilBrown wrote:
> On Sat, 09 Aug 2014 09:52:09 +0200 Killian De Volder
> <killian.de.volder@megasoft.be> wrote:
>
>> Doesn't work since sdb has been ejected. Strace below.
>>
>> package manager: mdadm 3.3-r2
>> #mdadm -V: mdadm - v3.3 - 3rd September 2013
>>
>> Just tried 3.3-r3 and 3.2.6-r1 same issue.
>> (There are no older in the package manager to try fast.)
>>
>> #strace mdadm /dev/md126 -r /dev/sdb2
> I note that you put "/dev/sdb2" on the end of the line.
>
>
>>> How about
>>>    mdadm /dev/md127 -r sdb2
> I note that I just put "sdb2" on the end of the line.  Perhaps I should have
> been explicit and say 'not "/dev/sdb2", just "sdb2"'.  It does make a
> difference.
>
> NeilBrown
>

