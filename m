From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: 3 questions...
Date: Mon, 30 Sep 2002 03:15:01 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D978975.2010903@tls.msk.ru>
References: <C65F89D1AC0BB54B865127151A24DA780BAD5C7B@nbexchm2.aliant.icn>	<3D977753.4010401@tls.msk.ru> <87k7l4zb8j.fsf@florent.hn.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Florent Rougon wrote:
[]
> I have some partitions with the fd type in raid arrays but would like to
> switch to the manual method you just described. These partitions hold
> data I care about. Is it safe to change the partition type:
>    - while the array is not active?
>    - while the array is active?

Hmm, it's always a good idea to have a backup handy, just in
case, right? ;)

Kernel code does not care about partition table _at all_ while
disk is in use - kernel reads partition table when disk usage
goes from 0 to 1, and keeps that table in memory after that, so
you may do with your partitions *anything* you like (incl. erasing
the whole table) while it's in use (but do not forget to restore
things before next reboot ;).  Concerning changing partition type,
well - having an accurate tool for this, it shuld be safe (an
operation is very simple, just changing one byte in disk's partition
table (an area that isn't used for anything else)).  So, answer
to both your question is yes, but see my first statement (in
fact, it is NOT completely safe to do ANYTHING at all with your
data - kernel may screw up and write random garbage to your
disks just at any time, even if you told it to mount a filesystem
read-only -- and disk may crash at random... ;).  Oh well... ;)
(don't panic, however - that's quite normal!.. ;)

/mj

