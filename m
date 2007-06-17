From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Software based SATA RAID-5 expandable arrays?
Date: Sun, 17 Jun 2007 18:23:22 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0706171820310.31588@p34.internal.lan>
References: <11167521.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <11167521.post@talk.nabble.com>
Sender: linux-raid-owner@vger.kernel.org
To: greenjelly <big_green_jelly_Bean@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sun, 17 Jun 2007, greenjelly wrote:

>
> I am researching my option to build a Media NAS server.  Sorry for the long
> message, but I wanted to provide as much details as possible to my problem,
> for the best solution.  I have Bolded sections as to save people who don't
> have the time to read all of this.
>
> Option 1: Expand My current Dream Machine!
> I could buying a RAID-5 Hardware card for my current system (vista ultimate
> 64 with a extreme 6800 and 1066mb 2 gig RAM).  The Adaptec RAID controller
> (model "3805", you can search NewEgg for the infomation) will cost me near
> $500 (consume 23w) and support 8 drives (I have 6).  This controller
> contains a 800mhz processor with a large cache of memory.  It will support
> expandable RAID-5 array!  I would also buy a 750w+ PSU (for the additional
> safety and security).  The drives in this machine would be placed in shock
> absorbing (noise reduction) 3 slot 4 drive bay containers with fans ( I have
> 2 of these) and I will be removing a IDE based Pioneer DVD Burner (1 of 3)
> because of its flaky performance given the p965 intel chip set lack of
> native IDE support and thus the Motherboards Micron SATA to IDE device.  Ive
> already installed 4 drives in this machine (on the native MB SATA
> controller) only to find a fan fail on me within days of the installation.
> One of the drives went bad (may or may not have to do with the heat).  There
> are 5mm between these drives, and I would now replace both fans with higher
> RPM ball baring fans for added reliability (more noise).  I would also need
> to find a Freeware SMART monitor software which at this time I can not find
> for Vista, to warn me of increased temps due to failure of fan, increased
> environmental heat, etc.  The only option is commercial SMART monitoring
> software (which may not work with the Adaptec RAID adapter.
>
> Option 2: Build a server.
> I have a copy of Windows 2003 server, which I have yet to find out if it
> supports native software expandable RAID-5 arrays.  I can also use Linux
> (which I have very little experience with) but have always wanted to use and
> learn.
>
> To do either of the last two options, I would still need to buy a new power
> supply for my current VISTA machine (for added reliability).  The current
> PSU is 550w and with a power hungry RADEON, 3 DVD Drives and a X-Fi sound
> card... My nerves are getting frayed.
>
> I would buy a cheap motherboard, processor and 1gig or less of RAM.  Lastly
> I would want a VERY large Case.  I have a 7300 NVidia PCI card that was
> replaced with a X1950GT on my Home Theater PC so that I may play back
> HD/Blue Ray DVD's.
>
> The server option may cost a bit more then the $500 for the Adaptec Raid
> controller.  This will only work if Linux or Windows 2003 supports my much
> needed requirements.  My Linux OS will be installed on a 40mb IDE Drive (not
> part of the Array).
>
> The options I seek are to be able to start with a 6 Drive array RAID-5
> array, then as my demand for more space increases in the future I want to be
> able to plug in more drives and incorporate them into the Array without the
> need to backup the data.  Basically I need the software to add the
> drive/drives to the Array, then Rebuild the array incorporating the new
> drives while preserving the data on the original array.
>
> QUESTIONS
> Since this is a media server, and would only be used to serve Movies and
> Video to my two machines It wouldn't have to be powered up full time (My
> Music consumes less space and will be contained on two seperate machines).
> Is there a way to considerably lower the power consumption of this server
> the 90% of time its not in use?
>
> Can Linux support Drive Arrays of Significant Sizes (4-8 terabytes)?
Yes, some reports of over 40-60TB.

>
> Can Linux Software support RAID-5 expandability, allowing me to increase the
> number of disks in the array, without the need to backup the media, recreate
> the array from scratch and then copy the backup to the machine (something I
> will be unable to do)?
With a recent kernel, yes.

>
> I know this is a Linux forum, but I figure many of you guys work with
> Windows Server.  If so does Windows 2003 provide the same support for the
> requested requirements above?
I hear Windows 2003 SW raid is extremely slow.

$ /usr/bin/time dd if=/dev/zero of=file bs=1M
dd: writing `file': No space left on device
1070704+0 records in
1070703+0 records out
1122713473024 bytes (1.1 TB) copied, 2565.89 seconds, 438 MB/s

$ time dd if=100gb of=/dev/null bs=1M count=102400
102400+0 records in
102400+0 records out
107374182400 bytes (107 GB) copied, 172.588 seconds, 622 MB/s

Sure its cached, and I could use the direct flag, but I do not use my 
disks with the cache turned off.

Most important thing is cooling IMO, make sure you get a good case.

^^ That is with 10 raptors and software raid5.  I'd use a separate Linux 
box with MD SW raid and have your dream machine separate.  If you use XFS 
make sure you buy yourself a UPS and then you'll have yourself a nice 
stable box.

Justin.

>
> Thanks
> GreenJelly
> -- 
> View this message in context: http://www.nabble.com/Software-based-SATA-RAID-5-expandable-arrays--tf3937421.html#a11167521
> Sent from the linux-raid mailing list archive at Nabble.com.
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
