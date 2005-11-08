From: Troels Bang Jensen <marvin@fnuck.dk>
Subject: Re: RAID 5 array keeps dropping drive on boot
Date: Tue, 8 Nov 2005 03:22:38 +0100
Message-ID: <B8B08849-784B-48A4-B49B-4F9FBEE2BCE9@fnuck.dk>
References: <2A807893-B5A6-4EF1-B862-1D6F22D71B60@fnuck.dk> <17263.57266.902113.362087@cse.unsw.edu.au> <5DD8751D-7FE2-4179-9887-853A704DE0D6@fnuck.dk> <17263.59743.163989.959271@cse.unsw.edu.au> <D8682F09-5A4D-4356-8FA6-825880F93AE4@fnuck.dk> <17263.61561.506974.198576@cse.unsw.edu.au> <4E521E9D-FDA7-4F7B-9E30-6DE568050214@fnuck.dk> <17264.1440.176313.287686@cse.unsw.edu.au>
Mime-Version: 1.0 (Apple Message framework v734)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17264.1440.176313.287686@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Nov 8, 2005, at 02:55 , Neil Brown wrote:

<snip>

> Can you find that ramdisk (probably in /boot/initrd* somewhere), mount
> it, (-t cramfs -o loop) and look inside it.
> Look particularly for /etc/mdadm.conf. but look around for anything
> else that might be related to md or raid.
>
> ... actually, you said which distribution you were using (Debian) so I
> should be able to figure it out from that...  Hm.. mkinitrd in pretty
> broken in debian wrt mdadm :-(
> You should find some script called 'md-1script' or something like that
> which has something like
>
>    mdadm -A /dev/md1 -R -u  4b22b17d:06048bd3:ecec156c:31fabbaf / 
> dev/hda3 /dev..
>
> This is probably broken.
>

Ah. In the file etc/script I found the line

mdadm -A /dev/md1 -R -u 4b22b17d:06048bd3:ecec156c:31fabbaf /dev/ 
hda3 /dev/hdg2

-wouldn't the best thing just be to add /dev/hdc3 there?

I'm terribly sorry, but it seems I've been wasting your time on

a) a Debian-specific question and

b) a problem I've caused myself.

You see, originally I was using a 2.4.17 kernel when the old drive  
crashed, but when I tried resyncing, the system froze.
Therefore I upgraded to the 2.6.12 kernel which had no problems  
syncing...but of course only hda3 and hdg2 were active at the time of  
installation, so the last drive didn't make it into the initrd image.

However, you've been incredibly helpful. You've solved my problem,  
thanks!

Troels
