From: Hubert Verstraete <hubskml@free.fr>
Subject: internal bitmap size
Date: Tue, 26 Feb 2008 18:35:23 +0100
Message-ID: <47C44DDB.3050201@free.fr>
References: <58CC73B2-35E8-412A-A7ED-8CACE786CE00@bj-ig.de>	<18218.60496.499724.710572@notabene.brown>	<70E97204-84DA-404E-9426-BDED1D4A1FE4@bj-ig.de> <18219.3453.415512.450789@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18219.3453.415512.450789@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

Neil Brown wrote:
> For now, you will have to live with a smallish bitmap, which probably
> isn't a real problem.  With 19078 bits, you will still get a
> several-thousand-fold increase it resync speed after a crash
> (i.e. hours become seconds) and to some extent, fewer bits are better
> and you have to update them less.
>
> I've haven't made any measurements to see what size bitmap is
> ideal... maybe someone should :-)

I've made some tries with a 4 250GB disks RAID-5 array and the write 
speed is really ugly with the default internal bitmap size.
Setting a bigger bitmap chunk size (16 MB for example) creates a small 
bitmap. The write speed is then almost the same as when there is no 
bitmap, which is great. And as you said, the resync is a matter of 
seconds (or minutes) instead of hours (without bitmap).
With such a setting, I've got both a nice write speed and a nice resync 
speed. That's where I would look at to find MY ideal bitmap size.

Neil, is there an issue to use the --bitmap-chunk option while using an 
internal bitmap ?
The man page does not clearly say to avoid using it and the mdadm source 
code does not prevent setting this size in the case of an internal bitmap.

Regarding my measurements, it showed that the default bitmap size is 4x 
slower than a small bitmap in v1.0 superblock. With v1.1 and v1.2 
superblocks, the default is 2x slower. We are far from the 10% slowdown 
claimed by http://linux-raid.osdl.org

I've also tried to play with the bitmap flush period (--delay option), 
but I would need to understand how it works to see if this can have an 
effect on performance.

Regards,
Hubert
