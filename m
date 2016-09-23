From: "Peter Sangas" <pete@wnsdev.com>
Subject: RE: Linux raid wiki
Date: Fri, 23 Sep 2016 12:02:28 -0700
Message-ID: <004e01d215cd$089e8090$19db81b0$@wnsdev.com>
References: <57E469E0.4020005@youngman.org.uk> <002a01d215c0$e3f20980$abd61c80$@wnsdev.com> <57E577BE.8080101@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57E577BE.8080101@youngman.org.uk>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: 'Wols Lists' <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Interesting: What about for a RAID1 array?.   My configuration is a 2 disk, 3 partition RAID1.  After installation of Ubuntu 16.04 the role numbers are 0 and 1.


Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5] [raid4][raid10] 
md2 : active raid1 sda3[0] sdb3[1]
      634795008 blocks super 1.2 [2/2] [UU]
      bitmap: 0/5 pages [0KB], 65536KB chunk

md1 : active raid1 sda2[0] sdb2[1]
      126887936 blocks super 1.2 [2/2] [UU]
      bitmap: 0/1 pages [0KB], 65536KB chunk

md0 : active raid1 sda1[0] sdb1[1]
      19514368 blocks super 1.2 [2/2] [UU]


But after I replace one of the drives (sdb) with a new drive and sync it the role number of md0,sdb1 changes from 1 to 2?  Is that supposed to happen?
 

Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5] [raid4][raid10] 
md2 : active raid1 sdb3[1] sda3[0]
      634795008 blocks super 1.2 [2/2] [UU]
      bitmap: 0/5 pages [0KB], 65536KB chunk

md1 : active raid1 sdb2[1] sda2[0]
      126887936 blocks super 1.2 [2/2] [UU]
      bitmap: 0/1 pages [0KB], 65536KB chunk

md0 : active raid1 sdb1[2] sda1[0]        
      19514368 blocks super 1.2 [2/2] [UU]


Thank you.

Pete
-----Original Message-----
From: Wols Lists [mailto:antlists@youngman.org.uk] 
Sent: Friday, September 23, 2016 11:43 AM
To: WNSDEV; linux-raid@vger.kernel.org
Subject: Re: Linux raid wiki

Thanks.

My understanding of role numbers is that they are the order of the disks in which stripes are written, so role 0 has the first stripe, role 1 the second, etc etc.

This is *normally* irrelevant, but should the array ever get trashed, the disks need to be listed *in* *that* *order* in a new --create statement.

Can someone - Neil? Phil? - please confirm I've understood that correctly before I update anything ...

(and I will be posting updates to the list - anything I'm not sure of I will be asking here to check I get it right :-)

Cheers,
Wol

On 23/09/16 18:35, WNSDEV wrote:
> Hi Wol,
> 
> Thanks for your work on the wiki... I'm sending a virtual bouquet.   I've been tracking down an issue regarding role numbers which I've posted to the list http://marc.info/?l=linux-raid&m=147439325405842&w=2.  In that process I've come across other postings that say information in the wiki is incorrect so maybe this is an opportunity to update this part of the wiki.
> 
> According to  https://raid.wiki.kernel.org/index.php/Mdstat  we find:
> 
> "The raid role numbers [#] following each device indicate its role, or function, within the raid set. Any device with "n" or higher are spare disks. 0,1,..,n-1 are for the working array. Notice that there is no device 3."
> 
> But according to the following two postings, 
> http://www.spinics.net/lists/raid/msg44491.html and 
> http://www.spinics.net/lists/raid/msg49766.html
> the information in the wiki about the numbers in brackets (role numbers ) is wrong.
> 
> Thanks,
> Peter Sangas
> 

