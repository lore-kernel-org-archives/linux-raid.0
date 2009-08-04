From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: auto start raid0 with no superblock?
Date: Wed, 05 Aug 2009 00:25:48 +0100
Message-ID: <4A78C37C.8010201@anonymous.org.uk>
References: <200908041444.52747.tfjellstrom@shaw.ca> <e95ccd4bcc42879717ea2ee8d02aaeba.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e95ccd4bcc42879717ea2ee8d02aaeba.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: tfjellstrom@shaw.ca, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/08/2009 23:35, NeilBrown wrote:
> On Wed, August 5, 2009 6:44 am, Thomas Fjellstrom wrote:
>> I'm testing out accessing a "Windows DynamicDisk Raid0" array under linux,
>> and
>> for the most part it works very well. My only problem is mdadm will not
>> auto
>> start the array even when I have it setup in mdadm.conf (mdadm is told to
>> auto
>> start all arrays found there). Basically I have to manually run "mdadm
>> --build
>> /dev/md0 --chunk=64 --level=raid0 --raid-devices=4 /dev/sdc1 /dev/sdd1
>> /dev/sde1 /dev/sdf1" then "mount /mnt/winraid" when I want to access the
>> filesystem (using ntfs-3g if anyone was wondering).
> 
> Of course you don't have to run it manually.  You can put it in
> a script in /etc/rc5.d/Sxxwhatever
> 
> That is in fact the recommended way of doing this.  There is really
> nothing that mdadm can do for you to make this any easier, so it
> doesn't bother.

It doesn't, and couldn't, support
   ARRAY /dev/md0 devices=/dev/sdc1,/dev/sdd1,/dev/sde1,/dev/sdf1 
level=0 metadata=none
appearing in mdadm.conf?

Cheers,

John.

