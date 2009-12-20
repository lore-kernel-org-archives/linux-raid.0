From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: Typical RAID5 transfer speeds
Date: Sun, 20 Dec 2009 11:31:11 +0100
Message-ID: <20091220103110.GA11852@rap.rap.dk>
References: <B26AD6F5-45F6-4CC6-AE63-E4253E60076C@mac.com>
 <20091220100450.GE15757@voyageur.mas.nom.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091220100450.GE15757@voyageur.mas.nom.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Erwan MAS <erwan@mas.nom.fr>
Cc: Matt Tehonica <matt.tehonica@mac.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Dec 20, 2009 at 11:04:50AM +0100, Erwan MAS wrote:
> On Fri, Dec 18, 2009 at 07:37:20PM -0500, Matt Tehonica wrote:
> > I have a 4 disk RAID5 using a 2048K chunk size and using XFS  
> > filesystem.  Typical file size is about 2GB-5GB. I usually get around  
> > 50MB/sec transfer speed when writting files to the array. Is this  
> > typcial or is it below normal?  A friend has a 20 disk RAID6 using the  
> > same filesystem and chunk size and gets around 150MB/sec. Any input on  
> > this??
> 
> You must be aware :
>  - each disk has physical limitations that depends from rpm
>  - that writing is slow on raid5 & raid6 .
> 
> With a raid5 device ,when writing a new block , you must :
>   - read the original block
>   - read the parity   block
>   - compute the new parity
>   - write the new block
>   - write the new parity
> 
> With a raid6 device ,when writing a new block , you must :
>   - read the original block
>   - read the parity 1  block
>   - read the parity 2  block
>   - compute the new parity 1
>   - compute the new parity 2
>   - write the new block
>   - write the new parity 1
>   - write the new parity 2
> 
> With cache , you can have better performance somes times , that depends of usage of device
> by the application .

There is also a mode for writing that detects that you are wiping many
blocks, and thus does not read the parity blocks nor the original
blocks. This is good for writing big files. The kernel detects this mode
for you, eg when writing large sequential files.


> Its'common to said that :
>   on raid 5    you have x4 penalty in writing 
>   on raid 6    you have x6 penalty in writing 
>   on raid 1/10 you have x2 penalty in writing 
>   on raid 0    you have no penalty in writing 

In the sequential mode, the penalty is then only 1 parity drive writing
for RAID5, and 2 drive writing for RAID6. This RAID5/6 can be much
faster than RAID1 (and RAID10) for writing.


> Its'common to said that :
>   one  15k rpm drive can do 180 random IO per second
>   one  10k rpm drive can do 140 random IO per second
>   one 7200 rpm drive can do  80 random IO per second

The elevator algorithm used can du much to improve these rates.

> If you have perfomance problem you must have more drive, because more drive give you more iops .

Or, if IOPS is your concern, then try SSD.

> If you have bad perfomance with raid5 during write you must try raid1 .
> 
> It's better to have many small disks that a big one , for perfomance . 
> 
> But for Electricity consumption , it's different :
>  2,5 drive use less electricity that 3,5 drive
>  slower in RPM drive use lesser electricity 
> 
> There no magic formula !
> 
> In your case :
>  you used 4 drives in raid5 , so when you write data , you have only the performance of one drive .
>  number_of_disk_in_the_array / 4 ( because you are in raid5 )
> 
> For your friend :
>  He used a 20 drives in raid6 , so when he write data , he have performance of 3.6 drives
>  number_of_disk_in_the_array / 6 ( because you are in raid6 )

Best regards
keld
