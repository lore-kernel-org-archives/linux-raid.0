From: Iordan Iordanov <iordan@cdf.toronto.edu>
Subject: Re: RAID for USB flash drives
Date: Mon, 17 Jan 2011 10:41:36 -0500
Message-ID: <4D346330.8080202@cdf.toronto.edu>
References: <AANLkTi=kcbanFit5x27ccS_1RChxC=Dn+Hs4Ak+FbKsX@mail.gmail.com>	<4D237E70.6030104@anonymous.org.uk> <AANLkTi=cOHgdradDDOFTdZ_xOGMXv8qf_n6xxppGA12y@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=cOHgdradDDOFTdZ_xOGMXv8qf_n6xxppGA12y@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Hank Barta <hbarta@gmail.com>
Cc: John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Hank,

On 01/14/11 18:25, Hank Barta wrote:
> I could also use 'debirf' as suggested by Iordan Iordanov, but I
> prefer to retain the full (disk based) environment with ease of
> installing and updating S/W. I haven't studied debirf but I suspect I
> would have to create and install a new image any time I want to update
> or install new packages.

Just to help clarify the debirf possibility. Debirf is Debian inside 
initrd, so yes, in order to make a change persistent, one would have to 
copy a new initrd over to the USB stick. However, since Debian is fully 
functional, running in a RAM disk, one is also able to install and 
update software on the fly using apt/aptitude. It's just that changes 
made to the ramdisk do not make it automatically into the initrd on the 
USB stick. You have to run one make command and copy the new image to 
the stick yourself. You can easily cron the building of the image, 
mounting of the USB stick, copying over, and unmounting once a day or 
week to keep the image up-to-date.

Also, all of this may be possible with Ubuntu, I just haven't had to do 
the research.

If you don't do debirf, don't forget to NOT put swap on the stick, and I 
would also make a ramdisk for /var/log and copy the logs to the stick 
upon shutdown (to prevent unnecessary flash wear as logs are gradually 
incremented).

Cheers and good luck!
Iordan
