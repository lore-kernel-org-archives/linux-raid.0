From: Monty Charlton <monty@fullmonty.org>
Subject: Re: raid 5 out of sync won't mount
Date: Tue, 18 Jun 2002 10:52:48 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D0F6560.5080102@fullmonty.org>
References: <3D0F4799.5090403@fullmonty.org> <20020618161549.GA17321@colombina.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Luca Berra wrote:
> On Tue, Jun 18, 2002 at 08:45:45AM -0600, Monty Charlton wrote:
> 
>>Hello all,
>>
>>I've got a helluva problem and I'm hoping someone here can possibly help 
>>out.
>>
>>I've got raid5 (sdb1,sbc1,sdd1) on a partition, and one of the drives 
>>(sdd1) went bad.  So I (stupidly) hit the reset button on the computer, 
>>but now the partition won't mount.  Raid complains that one drive is bad 
>>(which it is), and that the other is out of sync.  See part of dmesg 
>>below...
>>
>>Am I hosed?  Can I fake out raid by commenting out some of the code that 
>>tries to determine whether or not the drive is fresh?
> 
> edit /etc/raidtab
> mark the drive you know as bad as
> failed-disk instead of raid-disk
> run mkraid --force on the array
> read the message you get and do as instructed.

Thank you for the reply.

I read that in the howto, but feared it would destroy my data.  As the 
mkraid manpage says, "... destroys all of the data on the consituent 
devices."

I read the message, and am about to use the secret flag, but I want to 
be sure.  This will not simply wipe out my data?  This will only resync 
my two good drives?  Sorry to be such a coward...just trying to be sure 
of what I'm doing.

Thanks again,
Monty

