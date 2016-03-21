From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: problems with dm-raid 6
Date: Tue, 22 Mar 2016 10:48:19 +1100
Message-ID: <56F08843.4030909@websitemanagers.com.au>
References: <trinity-226526b2-6058-40bf-a276-9c1b47a80b3b-1458600120646@3capp-gmx-bs35>
 <56F07BBE.1010306@websitemanagers.com.au> <20160321231533.GB16913@EIS>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160321231533.GB16913@EIS>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Patrick Tschackert <Killing-Time@gmx.de>, lists@colorremedies.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22/03/16 10:15, Andreas Klauer wrote:
> On Tue, Mar 22, 2016 at 09:54:54AM +1100, Adam Goryachev wrote:
>> To my untrained eye, it looks like maybe the "first" drive in your array is correct, and
>> hence the first block returns the correct data so you can access the
>> LUKS, but the second (or third, or fourth) is damaged, and thats why you
>> can't read the filesystem inside the LUKS.
> This is a "problem" you get with arrays of many disks, if you "forget"
> the correct drive order and then "create" the RAID anew, it might
> result in a perfectly mountable filesystem but with errors down the
> way since the first "wrong" data may appear outside the filesystems
> immediate metadata zone, if two later disks switched places.
>
> However the OP only uses 64K chunksize, so that gives a lot less
> valid data than you'd get with 512K chunks. The LUKS header is already
> larger than 64K so if there is really bad data on one of the disks
> throughout, it's already quite lucky for the LUKS header to have
> survived. May be a good idea to grab a backup of that header while
> it's still working anyhow.
>
> The one disk full of bad data theory might not even be correct,
> maybe a sync started, and somehow the disk got accepted as fully
> synced even though it didn't... because the controller silently
> ignored all writes? Mysterious selective hardware failure?
>
>> Once you can do that, then either the filesystem will "Just Work" or
>> else you might need to do a repair depending on what exactly went wrong,
>> and how much was written during that time.
> Hope dies last.
>
> If btrfs stored data the same way a traditional filesystem would,
> uncompressed unencrypted unfragmented, you could hunt the raw data
> of your md for magic headers of known large files and see if you
> can tell in more detail the type of damage.
>
> For example if you could find a large megapixel JPEG image like
> that and were able to load it but it would appear corrupted at
> some point, the point of corruption might point you to the
> disk you no longer want to be in your array.
>
> But I don't know enough/anything about btrfs so not sure if viable.

All of that is true, but it is a LUKS (encrypted) partition, so even if 
the filesystem format was simple, you wouldn't be able to work it out 
because all the data is encrypted. (At least, that is the point of data 
encryption right.... in practice maybe there are still some options, but 
I'm definitely out of my depth there).

Regards,
Adam

-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
