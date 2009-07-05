From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: mdadm --wait doesn't
Date: Sun, 05 Jul 2009 21:54:11 +0100
Message-ID: <4A5112F3.8080504@anonymous.org.uk>
References: <cccedfc60907051035o1753ea61r7098c2ea2c8ded9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60907051035o1753ea61r7098c2ea2c8ded9@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/07/2009 18:35, Jon Nelson wrote:
> I was trying to use mdadm --wait a bit ago to wait for a recovery
> operation, but mdadm --wait didn't actually wait.
> 
> Here is md12 after adding /dev/sdf1 back to it.
> 
> md12 : active raid1 sdf1[3] nbd0[2](W)(F) sde[0]
>       72612988 blocks super 1.1 [3/1] [U__]
>       [>....................]  recovery =  3.0% (2195456/72612988)
> finish=51.4min speed=22805K/sec
>       bitmap: 139/139 pages [556KB], 256KB chunk
> 
> However, mdadm /dev/md12 --wait (and --wait-clean) did not wait for
> the recovery to be complete.
> 
> turnip:~ # mdadm /dev/md12 --wait
> turnip:~ # echo $?
> 0
> turnip:~ # mdadm --version
> mdadm - v3.0 - 2nd June 2009
> 
> I would --fail and --remove /dev/sdf1 and try again (with --add), and
> I did this several times, and I could not get it to wait until the
> recovery was complete.
> 
> Am I doing something wrong? Did I mis-read the documentation?

Did you try `mdadm --wait /dev/md12`? For me that returns 1 on a 
fully-up array (where there's nothing to wait for) while `mdadm 
/dev/md12 --wait` returns 0, so they're obviously handled differently. I 
don't really feel like degrading an array to test further, I'll leave it 
to you :-)

Cheers,

John.
