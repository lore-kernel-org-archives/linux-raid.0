From: Javier Marcet <jmarcet@gmail.com>
Subject: Re: Help with two momentarily failed drives out of a 4x3TB Raid 5
Date: Mon, 11 Mar 2013 20:03:36 +0100
Message-ID: <CAAnFQG__hwROJG1mE9BAaoapUDXTos+52udEp0yc6SfQz==DKA@mail.gmail.com>
References: <CAAnFQG8Ca7fkr-vboobr_qmRMTn38U9QP5hiT-9Ps0BqWcunzw@mail.gmail.com>
 <29375201.0.1362994874930.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <29375201.0.1362994874930.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Linux-RAID <linux-raid@vger.kernel.org>, =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
List-Id: linux-raid.ids

On Mon, Mar 11, 2013 at 10:41 AM, Roy Sigurd Karlsbakk
<roy@karlsbakk.net> wrote:

>> > As above. Also, I see no self-tests logged?
>>
>> I hadn't done any test manually but I had smartd running and
>> configured.
>
> smartd won't run any tests unless you configure it to do so.

I completely forgot to check the surfaces when I bought the disks. I
did quite a few tests before I decided to use ext4 but did not check
their health.

I have two disks still missing 30% of the long test but the two other
ones stopped due to errors:

http://bpaste.net/raw/83003/
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       18

http://bpaste.net/raw/83004/
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       1


I am gonna pass badblocks on them but this does not look good.

Could a faulty sata data cable cause those bad blocks? The disks are 8
months old so I hope I can get them replaced.



-- 
Javier Marcet <jmarcet@gmail.com>
