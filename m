From: Ron Leach <ronleach@tesco.net>
Subject: Re: If separate md for /boot, OS, and /srv, must 'create' on disks
 with 3 partns?
Date: Mon, 20 Jan 2014 16:53:05 +0000
Message-ID: <52DD5471.4070809@tesco.net>
References: <52DC1BED.7070901@tesco.net> <52DC39A7.5020506@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52DC39A7.5020506@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 19/01/2014 20:46, Phil Turmel wrote:
> On 01/19/2014 01:39 PM, Ron Leach wrote:
>> Assuming I am correct in needing something such as:
>>
>> /dev/md0 for Grub, (and copied to both physical disks of the RAID-1)
>> /dev/md1 for the OS, and
>
> I would use LVM here, too.
>

I wondered.  Would also enable me to reserve much less space for the 
OS and one or two small services that might be run there.  I'll read 
up on Grub over LVM, which is the only thing I'm not familiar with.

>> Should I proceed to partition the disks, and then create 3 RAID-1 arrays
>> (one on each partition-pair), or should I use a different
>> technique/layout to hold Grub, the OS, and an expandable LV for the
>> datafiles?
>
> How were you booting when the two disks were a single array?  Some other
> device?  If you can still do that, consider it.
>

It was another device - Debian on a separate single 250 GB sda.  With 
only 4 ports on the machine, and a wish to add another 2 x 3TB drives 
for the LVM, it won't be available.  Hence, I was working toward 
putting the OS on the RAID1 array, but now looking into putting the OS 
on the LVM, (as you suggest).

>
> For the small systems I've built lately, I've set up modest twin SSDs to
> handle boot, root, swap, database tablespaces, and mail storage.  Then
> added four or more large drives to handle media files.  The SSDs have a
> small partition for grub (raid1) and the balance in a single raid1 for
> LVM.

Noted, thanks.

>
> Oh, and don't forget a backup plan.  Raid redundancy is *not* backup.
>

Understood.  Incidentally, this server contains project file backups, 
and is primarily a backup repository so that we can recover from 
accidental deletion, or even retrieve previous project information for 
re-examination (should it become necessary).  We are not expecting to 
stream anything (well, not to date, anyway) so I don't expect 
bandwidth problems; we do have a lot of historic data including 
photographs, and project emails.  Relatively low traffic, but large 
capacity, and available on demand.  Additionally, we have a 
full-retention policy, which is imposing the capacity demands on this 
backup server.  We use incremental backup, with rdiff-backup which 
means that files once backed up don't get backed up again unless they 
change.

 From this machine, copies of the backup content will be made, in 
rotation, and held offsite.


> If you have bigger goals in mind, ignore me--do whatever Stan says
> (seriously).

Stan posts on several of the lists we follow, and I always read his 
contributions; many insights over the months and years.

Thanks for the guidance, and for confirming that separate RAID1s does 
imply separate partitions on the physical devices.  I've noted your 
(and David's, in another post) concerns about bandwidth and RAM.  I'll 
look into booting into the LVM, that's new to me.

regards, Ron
