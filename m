From: Steve Costaras <stevecs@chaven.com>
Subject: Re: mdadm / force parity checking of blocks on all reads?
Date: Fri, 18 Feb 2011 05:13:19 -0600
Message-ID: <4D5E544F.4090707@chaven.com>
References: <4D5DD3C0.3020804@chaven.com> <20110218142536.04d35fe5@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110218142536.04d35fe5@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 2011-02-17 21:25, NeilBrown wrote:
> On Thu, 17 Feb 2011 20:04:48 -0600 Steve Costaras<stevecs@chaven.com>  wrote:
>
>>
>> I'm looking at alternatives to ZFS since it still has some time to go
>> for large scale deployment as a kernel-level file system (and brtfs has
>> years to go).   I am running into problems with silent data corruption
>> with large deployments of disks.    Currently no hardware raid vendor
>> supports T10 DIF (which even if supported would only work w/ SAS/FC
>> drives anyway) nor does read parity checking.
> Maybe I'm just naive,  but find it impossible to believe that "silent data
> corruption" is ever acceptable.   You should fix or replace your hardware.
>
> Yes, I know silent data corruption is theoretically possible at a very low
> probability and that as you add more and more storage, that probability gets
> higher and higher.
>
> But my point is that the probability of unfixable but detectable corruption
> will ALWAYS be much (much much) higher than the probability of silent data
> corruption (on a correctly working system).
>
> So if you are getting unfixable errors reported on some component, replace
> that component.  And if you aren't then ask your vender to replace the
> system, because it is broken.
>
>
Would love to, do you have the home phone #'s of all the drive 
manufacturer's CTO's so I can talk to them?
It's a fact of life across /ALL/ drives.    This is 'SILENT' corruption, 
i.e. it's not reported by anything in the I/O chain as all systems 
'assume' the data is good in the request.    This concept has been 
proved flawed.

You can discover this by running (like we do here, sha1 hashes of all 
files and compare them over time).    We find on our 40TB arrays (this 
on drives w/ 10^15 BER and 1TB drives (seagate & hitachi) about 1-2 
mis-matches per month.   This requires us then to restore the data from 
tape (after also checking that).        This type of corruption is not 
unknown and is quite common (we first discovered it back in 2007-2008 
which is why I wrote up the scripts to check for it.   There has been a 
lot of discussion on this in the larger deployments  (I know that at 
least CERN has also seen it as they wrote a paper on it).    Ideally 
drive manufacturers should improve their BER to 10^17 or better for the 
large capacity drives (unfortunately its' the smaller drives that get 
the better BER (10^16)) and also allow for T10 DIF (520 byte sectors or 
4160byte if 4K).   However this standard was only adopted by the T10 
(SAS/SCSI group) not the T13 (SATA/IDE) group so that leaves another 
huge gap.   Let alone the lack of HBA's that support T10 DIF/fat sectors 
(LSI 9200 series is the only one I've found).    The only large capacity 
drive I've found that seems to have some additional protections is the 
Seagate ST32000444SS sas drive as it does ECC checks of each block at 
read time and tries to correct it.    From running 80 of these over the 
past several months I have not found an error that has reached user 
space /so far/.    However this just checks that the block ECC matches 
the block so a wild write or wild read request would go un-noticed 
(that's where DIF/DIX standard which also includes the LBA would be 
useful).

This is the real driving factor for ZFS as it does not require T10 DIF 
(fat sectors) or high BER drives (as manufacturers are not making them, 
a lot of 2TB and 3TB drives are rated even at 10^14!!!! )    ZFS works 
by creating it's own raid checksum and checking it on every transaction 
(read/write) at least in regards to this type of problem.    This same 
level of assurance can be accomplished by /any/ type of raid as the data 
is also already there but it needs to be checked on every transaction to 
verify it's integrity and if wrong corrected BEFORE handing it to user 
space.

If this is not something that is planned for mdadm then I'm back to 
solaris or freebsd for the mean time until native zfs is up to snuff.




